require "tempfile"
class GlusterFS::File
  attr_reader :volume, :path
  def initialize(volume, path)
    @volume = volume
    @path = path
  end

  def read_file(buf_size = 4092)
    check_exists
    fd = GlusterFS.open(@volume.fs, @path, 0)
    if path.include?('.')
      ext = '.' << path.split('.').pop
      temp = Tempfile.new([path.gsub('/', '-'), ext])
    else
      temp = Tempfile.new(path.gsub('/', '-'))
    end
    temp.binmode
    buff = FFI::MemoryPointer.new(:char, buf_size)
    res = 1
    while res > 0
      res = GlusterFS.read(fd, buff, buf_size, 0)
      temp.write(buff.get_bytes(0, res)) if res > 0
    end
    GlusterFS.close(fd)
    temp.rewind
    temp
  end

  def read(buf_size = 4092)
    check_exists
    fd = GlusterFS.open(@volume.fs, @path, 0)
    temp = ''
    buff = FFI::MemoryPointer.new(:char, buf_size)
    res = 1
    lstat
    while res > 0
      res = GlusterFS.read(fd, buff, buf_size, 0)
      temp << buff.get_bytes(0, res) if res > 0
    end
    GlusterFS.close(fd)
    temp
  end

  def write_file(file, perms = 0644, buffer_size = 4092)
    fd = GlusterFS.creat(@volume.fs, path, 2, perms)
    res = 0
    until file.eof?
      chunk = file.read(buffer_size)
      res += GlusterFS.write(fd, chunk, chunk.size , 0)
    end
    GlusterFS.close(fd)
    res
  end

  def write(data, perms = 0644)
    fd = GlusterFS.creat(@volume.fs, path, 2, perms)
    res = GlusterFS.write(fd, data, data.size, 0)
    GlusterFS.close(fd)
    res
  end

  def delete
    GlusterFS.unlink(@volume.fs, @path)
  end

  def lstat
    data = GlusterFS::Stat.new
    GlusterFS.lstat(@volume.fs, @path, data)
    data
  end

  def exists?
    GlusterFS::Stat.file?(lstat)
  end

  def size
    lstat[:st_size]
  end

  private

  # Reading non-existing file causes segfault on file.read
  def check_exists
    raise GlusterFS::Error, "File does not exist: #{@path}" unless exists?
  end

end
