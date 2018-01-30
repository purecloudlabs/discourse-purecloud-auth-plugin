require_dependency 'auth/oauth2_authenticator.rb'

GENESYS_PROD_ORG_ID = "845c9858-a978-4313-b8ed-2a85b289cffb"

#https://github.com/discourse/discourse-oauth2-basic
class PureCloudAuthenticator < ::Auth::OAuth2Authenticator
  @client_id = ""
  @client_secret = ""
  @provider_name = "purecloud"
  @region = "mypurecloud.com"

  def init_settings
      puts "Registering PC Auth settings"
      puts "ID: " + SiteSetting.purecloud_client_id
      @client_id = SiteSetting.purecloud_client_id
      @client_secret = SiteSetting.purecloud_client_secret
      @region = "mypurecloud.com"
      @provider_name = "purecloud"

      puts "Client ID: #{@client_id}"
  end

  def register_middleware(omniauth)
    omniauth.provider :purecloud,
                      name: @provider_name,
                      setup: lambda {|env|
                      	init_settings
                      	
                        opts = env['omniauth.strategy'].options
                        opts[:client_id] = @client_id
                        opts[:client_secret] = @client_secret

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
        if result.user == nil
            puts 'PURECLOUD - looking for user with this email'
            result.user = User.where(email: Email.downcase(result.email)).first
        end

        if result.user == nil
            puts 'PURECLOUD - looking for user with their ININ email'
            result.user = User.where(email: Email.downcase(result.email.sub(/@genesys.com/, "@inin.com"))).first
        end

        result.email_valid = true
    end


####### END EMPLOYEE SYNC

    result
  end

  def after_create_account(user, auth)
    ::PluginStore.set(@provider_name, "#{@provider_name}_user_#{auth[:extra_data][:purecloud_user_id]}", {user_id: user.id })
  end
end
