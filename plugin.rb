# name: purecloud-auth
# about: PureCloud login support for Discourse
# version: 0.1
# authors: Kevin Glinski
require_relative 'auth/pure_cloud_authenticator'
require_relative 'auth/pure_cloud_apne1_authenticator'
require_relative 'auth/pure_cloud_apse1_authenticator'
require_relative 'auth/pure_cloud_euw1_authenticator'
require_relative 'auth/pure_cloud_euc1_authenticator'

require_relative 'omniauth-purecloud'

#puts can be found on the docker container in /var/www/discourse/log/unicorn.stdout.log
puts 'PureCloud - plugin loaded'

FRAME_WIDTH = 600
FRAME_HEIGHT = 543
LOGIN_MESSAGE = 'Authorizing with PureCloud (make sure pop up blockers are not enabled)'

puts 'PureCloud - Registering AuthProviders'

auth_provider :title => 'Sign in with PureCloud Americas (mypurecloud.com)',
            :authenticator => PureCloudAuthenticator.new('purecloud_use1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with PureCloud Europe West (mypurecloud.ie)',
            :authenticator => PureCloudEuw1Authenticator.new('purecloud_euw1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with PureCloud Europe Central (mypurecloud.de)',
            :authenticator => PureCloudEuc1Authenticator.new('purecloud_euc1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with PureCloud APAC North (mypurecloud.jp)',
            :authenticator => PureCloudApne1Authenticator.new('purecloud_apne1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

auth_provider :title => 'Sign in with PureCloud APAC South (mypurecloud.com.au)',
            :authenticator => PureCloudApse1Authenticator.new('purecloud_apse1'),
            :message => LOGIN_MESSAGE,
            :frame_width => FRAME_WIDTH,
            :frame_height => FRAME_HEIGHT

puts 'PureCloud - plugin startup complete'
