require "tempfile"
class GlusterFS::File
  class << self
    def read(fs, path, buf_size = 4092)
      fd = GlusterFS.open(fs, path, 0)
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

    def write(fs, path, file, perms = 0644)
      fd = GlusterFS.creat(fs, path, 2, perms)
      res = GlusterFS.write(fd, file.read, file.size, 0)
      GlusterFS.close(fd)
      res
    end
  end
end
