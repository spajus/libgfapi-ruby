require 'rspec'
require 'glusterfs'
require 'pry'
require 'pry-nav'

GFS_SERVER_HOST = '127.0.0.1'
GFS_SERVER_PORT = 24007
GFS_VOLUME = 'dist-volume'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
