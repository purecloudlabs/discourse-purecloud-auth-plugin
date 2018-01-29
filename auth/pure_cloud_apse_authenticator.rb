require_dependency 'auth/oauth2_authenticator.rb'

#https://github.com/discourse/discourse-oauth2-basic
class PureCloudApseAuthenticator < PureCloudAuthenticator
  def init_settings
      puts "Registering PC APNE Auth settings"
      puts "ID: " + SiteSetting.purecloud_apse_client_id
      @client_id = SiteSetting.purecloud_apse_client_id
      @client_secret = SiteSetting.purecloud_apse_client_secret
      @region = "mypurecloud.com.au"
      @provider_name = "purecloud_apse"
  end
end
