require 'ruby-mass'
module GlusterFS

  def self.mem_size
    ObjectSpace.garbage_collect
    _, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
    size.to_i
  end

  describe 'memleaks' do

    let(:iterations) { (ENV['MEM_ITERATIONS'] || 100).to_i }

    before(:all) do
      if ENV['MEM_PRINT']
        puts "GC Settings"
        puts "RUBY_HEAP_MIN_SLOTS=#{ENV['RUBY_HEAP_MIN_SLOTS']}"
        puts "RUBY_HEAP_SLOTS_INCREMENT=#{ENV['RUBY_HEAP_SLOTS_INCREMENT']}"
        puts "RUBY_HEAP_SLOTS_GROWTH_FACTOR=#{ENV['RUBY_HEAP_SLOTS_GROWTH_FACTOR']}"
        puts "RUBY_GC_MALLOC_LIMIT=#{ENV['RUBY_GC_MALLOC_LIMIT']}"
        puts "RUBY_FREE_MIN=#{ENV['RUBY_FREE_MIN']}"
        puts "Initial memory use: #{GlusterFS.mem_size}"
        Mass.print
      else
        puts "Set MEM_PRINT=1 MEM_ITERATIONS=10000 to get a better memory stress test"
      end
    end

    let!(:random_blob) do
      '0' * 1048576 * 5 # 5MB
    end
    let(:volume) { Volume.new(GFS_VOLUME)
                         .mount(GFS_SERVER_HOST, GFS_SERVER_PORT) }
    let(:root_dir) { Directory.new(volume, '/memtest-root') }

    # Mem leak here! Only run when MEM_ITERATIONS is provided.
    if ENV['MEM_ITERATIONS']
      context 'mount / unmount volume' do
        specify do
          puts "Volume Iterations: #{iterations}"
          mem_size_before = GlusterFS.mem_size
          iterations.times do |i|
            vol = Volume.new(GFS_VOLUME)
            vol.mount(GFS_SERVER_HOST, GFS_SERVER_PORT)
            vol.unmount
            puts i
          end
          mem_size = GlusterFS.mem_size
          puts "Mem growth: #{mem_size - mem_size_before}"
          Mass.print if ENV['MEM_PRINT']
          (mem_size - mem_size_before).should be < 10240
        end
      end
    end

    context 'create many directories' do
      before { root_dir.create }
      after { root_dir.delete }
      specify do
        puts "Dir Iterations: #{iterations}"
        mem_size_before = GlusterFS.mem_size
        iterations.times do |i|
          dir = Directory.new(volume, "#{root_dir.path}/subdir-#{i}")
          dir.create
          dir.delete
        end
        mem_size = GlusterFS.mem_size
        puts "Mem growth: #{mem_size - mem_size_before}"
        Mass.print if ENV['MEM_PRINT']
        (mem_size - mem_size_before).should be < 10240
      end
    end

    context 'create many files' do
      before { root_dir.create }
      after { root_dir.delete }
      specify do
        puts "File Iterations: #{iterations}"
        mem_size_before = GlusterFS.mem_size
        iterations.times do |i|
          file = File.new(volume, "#{root_dir.path}/file-#{i}")
          file.write(random_blob)
          file.delete
        end
        mem_size = GlusterFS.mem_size
        puts "Mem growth: #{mem_size - mem_size_before}"
        Mass.print if ENV['MEM_PRINT']
        (mem_size - mem_size_before).should be < 10240
      end
    end
  end
end
