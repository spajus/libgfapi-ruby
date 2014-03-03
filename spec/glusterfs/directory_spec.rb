require 'spec_helper'

module GlusterFS
  describe Directory do
    let(:volume) { Client.mount(GFS_VOLUME, GFS_SERVER_HOST) }
    let(:dir_name) { "test-#{Time.now.to_i}" }
    let(:dir) { Directory.new(volume, dir_name) }

    after do
      dir.delete
      volume.unmount
    end

    context '#create' do
      before { dir.create }
      subject { dir.exists? }
      it { should be_true }
    end

    context '#delete' do
      before do
        dir.create
        dir.delete
      end
      subject { dir.exists? }
      it { should_not be_true }
    end

    context '#exist?' do
      subject { dir.exists? }

      context 'on existing dir' do
        before { dir.create }
        it { should be_true }
      end

      context 'on non-existing file' do
        it { should_not be_true }
      end
    end

    context '#lstat' do
      context 'on existing dir' do
        before { dir.create }
        let(:lstat) { dir.lstat }
        specify 'lstat response is as expected' do
          lstat[:st_dev].should_not == 0
          lstat[:st_ino].should_not == 0
          lstat[:st_nlink].should_not == 0
          lstat[:st_mode].should_not == 0
          lstat[:st_uid].should == 0
          lstat[:st_gid].should == 0
          lstat[:st_rdev].should == 0
          lstat[:st_size].should_not == 0
          lstat[:st_blksize].should == 0
          lstat[:st_blocks].should be > 1
          lstat[:st_atime].should_not == 0
          lstat[:st_mtime].should_not == 0
          lstat[:st_ctime].should_not == 0
          lstat[:st_atimesec].should_not == 0
          lstat[:st_mtimesec].should_not == 0
          lstat[:st_ctimesec].should_not == 0
        end
      end

      context 'on non-existing dir' do
        let(:lstat) { dir.lstat }
        specify 'lstat response is as expected' do
          lstat[:st_dev].should == 0
          lstat[:st_ino].should == 0
          lstat[:st_nlink].should == 0
          lstat[:st_mode].should == 0
          lstat[:st_uid].should == 0
          lstat[:st_gid].should == 0
          lstat[:st_rdev].should == 0
          lstat[:st_size].should == 0
          lstat[:st_blksize].should == 0
          lstat[:st_blocks].should == 0
          lstat[:st_atime].should == 0
          lstat[:st_mtime].should == 0
          lstat[:st_ctime].should == 0
          lstat[:st_atimesec].should == 0
          lstat[:st_mtimesec].should == 0
          lstat[:st_ctimesec].should == 0
        end
      end
    end
  end
end
