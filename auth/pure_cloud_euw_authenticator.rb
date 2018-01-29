require_dependency 'auth/oauth2_authenticator.rb'

#https://github.com/discourse/discourse-oauth2-basic
class PureCloudEuwAuthenticator < PureCloudAuthenticator

  def init_settings
      puts "Registering PC EUW Auth settings"
      puts "ID: " + SiteSetting.purecloud_euw_client_id
      @client_id = SiteSetting.purecloud_euw_client_id
      @client_secret = SiteSetting.purecloud_euw_client_secret
      @region = "mypurecloud.ie"
      @provider_name = "purecloud_euw"
  end

end
