require 'spec_helper'

module GlusterFS
  describe GlusterFS::Client do
    it 'mounts volume' do
      volume = GlusterFS::Client.mount(GFS_VOLUME, GFS_SERVER_HOST)
      volume.name.should == GFS_VOLUME
    end
  end
end
