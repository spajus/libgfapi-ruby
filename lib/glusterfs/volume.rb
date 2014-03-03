class GlusterFS::Volume
  attr_reader :name, :fs, :mounted

  def initialize(name)
    @name = name
    @fs = GlusterFS.new(@name)
    self
  end

  def mount(host, port = 24007, protocol = 'tcp')
    GlusterFS.set_volfile_server(@fs, protocol, host, port)
    result = GlusterFS.init(@fs)
    if result != 0
      raise GlusterFS::Error,
        "Failed to mount volume '#{volume_name}' on #{protocol}://#{host}:#{port}"
    end
    @mounted = true
    self
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
end
