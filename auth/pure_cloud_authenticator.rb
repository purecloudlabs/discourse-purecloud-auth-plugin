require_dependency 'auth/oauth2_authenticator.rb'

GENESYS_PROD_ORG_ID = "845c9858-a978-4313-b8ed-2a85b289cffb"

#https://github.com/discourse/discourse-oauth2-basic
class PureCloudAuthenticator < ::Auth::OAuth2Authenticator
  @provider_name = "purecloud_use1"
  @region = "mypurecloud.com"

  def init_settings
      @region = "mypurecloud.com"
      @provider_name = "purecloud_use1"
      puts "Initializing PureCloud OAuth settings"
      puts "Provider: " + @provider_name
      puts "Region: " + @region
  end

  def register_middleware(omniauth)
  	init_settings

    omniauth.provider :purecloud,
                      name: @provider_name,
                      setup: lambda {|env|
                      	puts "Registering middleware for PureCloud OAuth provider: " + @provider_name
                      	puts "Client ID: " + SiteSetting.purecloud_use1_client_id

                        opts = env['omniauth.strategy'].options
                        opts[:client_id] = SiteSetting.purecloud_use1_client_id
                        opts[:client_secret] = SiteSetting.purecloud_use1_client_secret

                        opts[:client_options] = {
                          site: "https://login.#{@region}/"
                        }
                      }
  end

  def fetch_user_details(token)
    user_json_url = "https://api.#{@region}/api/v2/users/me?expand=organization"
    user_json = JSON.parse(open(user_json_url, 'Authorization' => "Bearer #{token}" ).read)
    puts user_json

    result = {
      :name     => user_json['name'],
      :email    => user_json['email'],
      :user_id => user_json["id"],
      :username => user_json["name"],
      :org_id => user_json["organization"]["id"]
    }

    result
  end

  def after_authenticate(auth)
	  result = Auth::Result.new
  	
  	begin
	    token = auth['credentials']['token']
	    user_details = fetch_user_details(token)

	    result.name = user_details[:name]
	    result.username = user_details[:username]
	    result.email = user_details[:email]

	    #purecloud doesn't have a concept of a validated email
	    result.email_valid = false

	    current_info = ::PluginStore.get(@provider_name, "#{@provider_name}_user_#{user_details[:user_id]}")
	    if current_info
	      result.user = User.where(id: current_info[:user_id]).first
	    end

	    result.extra_data = {
        purecloud_user_id: user_details[:user_id],
        purecloud_org_id: user_details[:org_id]
	    }

			####### BEGIN EMPLOYEE SYNC
	    #Special logic for the prod genesys org
	    if(result.extra_data[:purecloud_org_id] == GENESYS_PROD_ORG_ID)
	    	email_token = ActiveRecord::Base.exec_sql("SELECT * FROM email_tokens WHERE email='" + result.email.downcase + "' ORDER BY id DESC LIMIT 1")
	    	if email_token.present
	    		result.user = User.where(id: email_token[0].id).first
	    	end

	    	if result.user != nil
	    		result.email_valid = true
	    	end
	    end
			####### END EMPLOYEE SYNC
	  rescue => e
	  	puts "Exception Class: #{ e.class.name }"
		  puts "Exception Message: #{ e.message }"
		  puts "Exception Backtrace: #{ e.backtrace }"
	  end

	  result
  end

  def after_create_account(user, auth)
    ::PluginStore.set(@provider_name, "#{@provider_name}_user_#{auth[:extra_data][:purecloud_user_id]}", {user_id: user.id })
  end
end
