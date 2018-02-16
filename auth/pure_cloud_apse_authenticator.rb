require_dependency 'auth/oauth2_authenticator.rb'

#https://github.com/discourse/discourse-oauth2-basic
class PureCloudApseAuthenticator < PureCloudAuthenticator
  def init_settings
      @region = "mypurecloud.com.au"
      @provider_name = "purecloud_apse"
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
                      	puts "Client ID: " + SiteSetting.purecloud_apse_client_id

                        opts = env['omniauth.strategy'].options
                        opts[:client_id] = SiteSetting.purecloud_apse_client_id
                        opts[:client_secret] = SiteSetting.purecloud_apse_client_secret

                        opts[:client_options] = {
                          site: "https://login.#{@region}/"
                        }
                      }
  end
end
