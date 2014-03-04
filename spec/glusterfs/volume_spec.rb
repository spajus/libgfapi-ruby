require 'spec_helper'

module GlusterFS
  describe Volume do
    let(:volume) { Volume.new(GFS_VOLUME) }

    after(:each) { volume.unmount if volume.mounted? }

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

    context '#lstat' do
      context 'on file' do
        let(:file_name) { "test-stat-#{Time.now.to_i}" }
        let(:file) { File.new(volume, file_name) }
        let(:data) { '123' }
        before do
          volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT)
          file.write(data)
        end
        after { file.delete }
        subject { volume.lstat(file.path) }
        its([:st_size]) { should == file.size }
      end

      context 'on directory' do
        let(:dir_name) { "test-#{Time.now.to_i}" }
        let(:dir) { Directory.new(volume, dir_name) }
        before do
          volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT)
          dir.create
        end
        after { dir.delete }
        subject { volume.lstat(dir.path) }
        its([:st_blksize]) { should == dir.lstat[:st_blksize] }
      end

      specify 'raise error when unmounted' do
        expect { volume.lstat('/foo/bar') }.to raise_error(GlusterFS::Error)
      end
    end

    context '#delete_dir' do
      let(:dir_name) { "test-#{Time.now.to_i}" }
      let(:dir) { Directory.new(volume, dir_name) }
      before do
        volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT)
        dir.create
      end
      before { volume.delete_dir(dir.path) }
      subject { dir.exists? }
      it { should_not be_true }
    end

    context '#delete_file' do
      let(:file_name) { "test-stat-#{Time.now.to_i}" }
      let(:file) { File.new(volume, file_name) }
      let(:data) { '123' }
      before do
        volume.mount(GFS_SERVER_HOST, GFS_SERVER_PORT)
        file.write(data)
      end
      before { volume.delete_file(file.path) }
      subject { file.exists? }
      it { should_not be_true }
    end

    context '#mounted?' do
      before { volume.unmount }
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
