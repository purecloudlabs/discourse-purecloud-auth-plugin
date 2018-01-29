require_dependency 'auth/oauth2_authenticator.rb'

#https://github.com/discourse/discourse-oauth2-basic
class PureCloudApneAuthenticator < PureCloudAuthenticator
  def init_settings
      puts "Registering PC APNE Auth settings"
      puts "ID: " + SiteSetting.purecloud_apne_client_id
      @client_id = SiteSetting.purecloud_apne_client_id
      @client_secret = SiteSetting.purecloud_apne_client_secret
      @region = "mypurecloud.jp"
      @provider_name = "purecloud_apne"
  end
end
