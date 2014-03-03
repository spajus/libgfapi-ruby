require 'rspec'
require 'glusterfs'

GFS_SERVER_HOST = ENV['GFS_SERVER_HOST'] || '127.0.0.1'
GFS_SERVER_PORT = (ENV['GFS_SERVER_PORT'] || 24007).to_i
GFS_VOLUME = ENV['GFS_VOLUME_NAME'] || 'dist-volume'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
