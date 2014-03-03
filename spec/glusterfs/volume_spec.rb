require 'spec_helper'

module GlusterFS
  describe Volume do
    let(:volume) { Volume.new(GFS_VOLUME) }

    context '#mount' do
      before { volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT) }
      subject { volume.mounted? }
      it { should be_true }
    end

    context '#unmount' do
      before do
        volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT)
        volume.unmount
      end
      subject { volume.mounted? }
      it { should_not be_true }
    end

    context '#mounted?' do
      subject { volume.mounted? }

      context 'on mounted volume' do
        before { volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT) }
        it { should be_true }
      end

      context 'on unmounted volume' do
        it { should_not be_true }
      end
    end
  end
end
