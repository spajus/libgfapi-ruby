require 'rspec'
require 'glusterfs'

GFS_SERVER_HOST = ENV['GFS_SERVER_HOST'] || '127.0.0.1'
GFS_SERVER_PORT = (ENV['GFS_SERVER_PORT'] || 24007).to_i
GFS_VOLUME = ENV['GFS_VOLUME_NAME'] || 'dist-volume'
GFS_FS_MOUNT = ENV['GFS_FS_MOUNT'] || '/mnt/dist-volume'

# Settings for stress tests
GFS_MEM_DIR_ITERATIONS = (ENV['MEM_DIR_ITERATIONS'] || 50).to_i
GFS_MEM_FILE_ITERATIONS = (ENV['MEM_FILE_ITERATIONS'] || 50).to_i
GFS_MEM_VOL_ITERATIONS = (ENV['MEM_VOL_ITERATIONS'] || 50).to_i

GFS_MEM_PRINT = ENV['MEM_PRINT'] || false

GFS_PERF_NATIVE_ITERATIONS = (ENV['PERF_NATIVE_ITERATIONS'] || 10).to_i
GFS_PERF_MOUNT_ITERATIONS = (ENV['PERF_MOUNT_ITERATIONS'] || 10).to_i
GFS_PERF_API_ITERATIONS = (ENV['PERF_API_ITERATIONS'] || 10).to_i

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
