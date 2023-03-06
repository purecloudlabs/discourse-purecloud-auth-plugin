require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class GenesysCloud < ::OmniAuth::Strategies::OAuth2
      option :name, "genesysCloud"

      def callback_url
        Discourse.base_url_no_prefix + script_name + callback_path
      end

    end
  end
end
