# name: genesyscloud-auth
# about: Genesys Cloud login support for Discourse
# version: 0.2
# authors: Genesys
require_relative 'auth/genesys_cloud_authenticator'
require_relative 'auth/genesys_cloud_usw2_authenticator'
require_relative 'auth/genesys_cloud_cac1_authenticator'
require_relative 'auth/genesys_cloud_euw1_authenticator'
require_relative 'auth/genesys_cloud_euw2_authenticator'
require_relative 'auth/genesys_cloud_euc1_authenticator'
require_relative 'auth/genesys_cloud_apne1_authenticator'
require_relative 'auth/genesys_cloud_apne2_authenticator'
require_relative 'auth/genesys_cloud_apse1_authenticator'

require_relative 'omniauth-genesys-cloud'

#puts can be found on the docker container in /var/www/discourse/log/unicorn.stdout.log
puts 'Genesys Cloud - plugin loaded'

FRAME_WIDTH = 600
FRAME_HEIGHT = 543
LOGIN_MESSAGE = 'Authorizing with Genesys Cloud (make sure pop up blockers are not enabled)'

puts 'Genesys Cloud - Registering AuthProviders'

auth_provider :title => 'Sign in with Genesys Cloud US East (mypurecloud.com)',
            :authenticator => GenesysCloudAuthenticator.new('genesys_cloud_use1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud US West (usw2.pure.cloud)',
            :authenticator => GenesysCloudUsw2Authenticator.new('genesys_cloud_usw2'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud Canada (cac1.pure.cloud)',
            :authenticator => GenesysCloudCac1Authenticator.new('genesys_cloud_cac1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud EU West (Ireland) (mypurecloud.ie)',
            :authenticator => GenesysCloudEuw1Authenticator.new('genesys_cloud_euw1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud EU West (London) (euw2.pure.cloud)',
            :authenticator => GenesysCloudEuw2Authenticator.new('genesys_cloud_euw2'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud EU Central (mypurecloud.de)',
            :authenticator => GenesysCloudEuc1Authenticator.new('genesys_cloud_euc1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud APAC Northeast (Tokyo) (mypurecloud.jp)',
            :authenticator => GenesysCloudApne1Authenticator.new('genesys_cloud_apne1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud APAC Northeast (Seoul) (apne2.pure.cloud)',
            :authenticator => GenesysCloudApne2Authenticator.new('genesys_cloud_apne2'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with Genesys Cloud APAC South (mypurecloud.com.au)',
            :authenticator => GenesysCloudApse1Authenticator.new('genesys_cloud_apse1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

puts 'Genesys Cloud - plugin startup complete'
