require 'ruby-mass'
require 'fileutils'
require 'benchmark'
module GlusterFS

  describe 'performance' do
    let(:file_mount_point) { ENV['GFS_MOUNT_DIR'] || '/mnt/dist-volume' }
    let(:iterations) { (ENV['PERF_ITERATIONS'] || 3000).to_i }
    let!(:random_blob) do
      '0' * 1048576 * 5 # 5MB
    end

    specify 'native file system operations' do
      test_dir ="/tmp/fs-perftest-root"
      FileUtils.rm_rf test_dir
      time = Benchmark.realtime do
        FileUtils.mkdir_p test_dir
        iterations.times do |i|
          dir = "#{test_dir}/perf-test-#{i}"
          FileUtils.mkdir dir
          file = "#{dir}/file-#{i}"
          ::File.open(file, 'w+') do |f|
            f.write(random_blob)
          end
          FileUtils.rm(file)
          FileUtils.rmdir(dir)
        end
        FileUtils.rmdir(test_dir)
      end
      puts "Native FS Time: #{iterations} iterations: #{'%.4f' % time} sec"
    end

    specify 'mounted file system operations' do
      test_dir ="#{file_mount_point}/mnt-perftest-root"
      FileUtils.rm_rf test_dir
      time = Benchmark.realtime do
        FileUtils.mkdir_p test_dir
        iterations.times do |i|
          dir = "#{test_dir}/perf-test-#{i}"
          FileUtils.mkdir dir
          file = "#{dir}/file-#{i}"
          ::File.open(file, 'w+') do |f|
            f.write(random_blob)
          end
          FileUtils.rm(file)
          FileUtils.rmdir(dir)
        end
        FileUtils.rmdir(test_dir)
      end
      puts "Mounted FS Time: #{iterations} iterations: #{'%.4f' % time} sec"
    end

    let(:volume) { Volume.new(GFS_VOLUME)
                         .mount(GFS_SERVER_HOST, GFS_SERVER_PORT) }
    specify 'api operations' do
      test_dir ="/gfs-perftest-root"
      FileUtils.rm_rf "#{file_mount_point}/test_dir"
      time = Benchmark.realtime do
        gfs_test_dir = Directory.new(volume, test_dir)
        gfs_test_dir.create
        iterations.times do |i|
          dir = "#{test_dir}/perf-test-#{i}"
          gfs_dir = Directory.new(volume, dir)
          gfs_dir.create
          file = "#{dir}/file-#{i}"
          gfs_file = File.new(volume, file)
          gfs_file.write(random_blob)
          gfs_file.delete
          gfs_dir.delete
        end
        gfs_test_dir.delete
      end
      puts "GFS API Time: #{iterations} iterations: #{'%.4f' % time} sec"
    end

  end
end
