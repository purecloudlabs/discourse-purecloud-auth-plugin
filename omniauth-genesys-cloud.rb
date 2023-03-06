require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class ::OmniAuth::Strategies::Oauth2Basic < ::OmniAuth::Strategies::OAuth2
      option :name, "genesysCloud"

      option :client_options, {
          authorize_url: '/oauth/authorize',
          token_url:     '/oauth/token'
          site: 'https://login.mypurecloud.com'
      }

      option :authorize_options, [:scope]

      def callback_url
        full_host + script_name + callback_path
      end

    end
  end
end
