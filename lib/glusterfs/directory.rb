class GlusterFS::Directory
  attr_reader :volume, :path
  def initialize(volume, path)
    @volume = volume
    @path = path
  end

  def create(perms = 0755)
    GlusterFS.mkdir(@volume.fs, @path, perms)
  end

  def delete
    GlusterFS.rmdir(@volume.fs, @path)
  end

  def lstat
    data = GlusterFS::Stat.new
    GlusterFS.lstat(@volume.fs, @path, data)
    data
  end

  def exists?
    lstat[:st_size] > 0
  end
end
