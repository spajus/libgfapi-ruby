require "tempfile"
class GlusterFS::File
  attr_reader :volume, :path
  def initialize(volume, path)
    @volume = volume
    @path = path
  end

  def read_file(buf_size = 4092)
    raise GlusterFS::Error, "File is empty or does not exist: #{@path}" if lstat[:st_size] < 1
    fd = GlusterFS.open(@volume.fs, @path, 0)
    temp = Tempfile.new(path.gsub('/', '-'))
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

  def write_file(file, perms = 0644)
    fd = GlusterFS.creat(@volume.fs, path, 2, perms)
    res = GlusterFS.write(fd, file.read, file.size, 0)
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
    lstat[:st_blocks] > 0
  end

  def size
    lstat[:st_size]
  end

end
