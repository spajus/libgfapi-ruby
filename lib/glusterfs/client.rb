class GlusterFS::Client
  class << self
    def mount(volume_name, host, port = 24007, protocol = 'tcp')
      volume = GlusterFS::Volume.new(volume_name)
      volume.mount(host, port, protocol)
      volume
    end

    def unmount(volume)
      GlusterFS.fini(volume.fs)
    end
  end
end
