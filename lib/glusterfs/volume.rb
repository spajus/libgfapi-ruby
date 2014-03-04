class GlusterFS::Volume
  attr_reader :name, :fs, :mounted, :protocol, :host, :port

  def initialize(name)
    @name = name
    @fs = GlusterFS.new(@name)
    self
  end

  def mount(host, port = 24007, protocol = 'tcp')
    raise GlusterFS::Error, "Already mounted: #{self}" if mounted?
    GlusterFS.set_volfile_server(@fs, protocol, host, port)
    result = GlusterFS.init(@fs)
    raise GlusterFS::Error, "Failed to mount volume #{self}" if result != 0
    @mounted = true
    @host = host
    @protocol = protocol
    @port = port
    self
  end

  def lstat(path)
    check_mounted
    data = GlusterFS::Stat.new
    GlusterFS.lstat(@fs, path, data)
    data
  end

  def list(path)
    dir = Directory.new(volume, path)
    dir.list
  end

  def delete_file(path)
    check_mounted
    GlusterFS.unlink(@fs, path)
  end

  def delete_dir(path)
    check_mounted
    GlusterFS.rmdir(@fs, path)
  end

  def mounted?
    @mounted
  end

  def unmount
    if mounted?
      GlusterFS.fini(@fs)
      @mounted = false
      true
    end
  end

  private

  def to_s
    if mounted?
      "GlusterFS::Volume['#{@name}' on #{protocol}://#{host}:#{port}]"
    else
      "GlusterFS::Volume['#{@name}' (unmounted)]"
    end
  end

  def check_mounted
    raise GlusterFS::Error, "Volume not mounted: #{self}" unless mounted?
  end
end
