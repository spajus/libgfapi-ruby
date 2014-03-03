require 'spec_helper'

module GlusterFS
  describe File do
    let(:volume) { Volume.new(GFS_VOLUME)
                         .mount(GFS_SERVER_HOST, GFS_SERVER_PORT) }
    let(:file_name) { "test-#{Time.now.to_i}" }
    let(:file) { File.new(volume, file_name) }
    let(:data) { '123' }

    after do
      file.delete
      volume.unmount
    end

    context '#read' do
      before { file.write(data) }
      subject { file.read }
      it { should == data }
    end

    context '#read_file' do
      before { file.write(data) }
      let(:result) { file.read_file }
      specify 'result is correctly formed tempfile' do
        result.should be_a Tempfile
        result.read.should == data
        result.close
      end
    end

    context '#write' do
      context 'writes file' do
        subject { file.write(data) }
        it('returns bytes written') { should == data.length }
      end

      context 'overwrites file' do
        let(:file2) { File.new(volume, file_name) }
        let(:data2) { '1234' }

        before { file.write(data) }
        after { file2.delete }

        subject { file2.write(data2) }
        it('returns bytes written') { should == data2.length }
      end
    end

    context '#write_file' do
      let(:data) do
        d = Tempfile.new('test')
        d.write '12345'
        d.rewind
        d
      end
      after { data.close }

      context 'writes file' do
        subject { file.write_file(data) }
        it('returns bytes written') { should == data.length }
      end

      context 'overwrites file' do
        let(:file2) { File.new(volume, file_name) }
        let(:data2) do
          d = Tempfile.new('test2')
          d.write '7890'
          d.rewind
          d
        end

        before { file.write_file(data) }
        after do
          file2.delete
          data2.close
        end

        subject { file2.write_file(data2) }
        it('returns bytes written') { should == data2.length }
      end
    end

    context '#delete' do
      before do
        file.write(data)
        file.delete
      end
      subject { file.exists? }
      it('deletes the file') { should_not be_true }
    end

    context '#exist?' do
      subject { file.exists? }

      context 'on existing file' do
        before { file.write(data) }
        it { should be_true }
      end

      context 'on non-existing file' do
        it { should_not be_true }
      end
    end

    context '#lstat' do
      context 'on existing file' do
        before { file.write(data) }
        let(:lstat) { file.lstat }
        specify 'lstat response is as expected' do
          lstat[:st_dev].should_not == 0
          lstat[:st_ino].should_not == 0
          lstat[:st_nlink].should_not == 0
          lstat[:st_mode].should_not == 0
          lstat[:st_uid].should == 0
          lstat[:st_gid].should == 0
          lstat[:st_rdev].should == 0
          lstat[:st_size].should == data.size
          lstat[:st_blksize].should_not == 0
          lstat[:st_blocks].should == 1
          lstat[:st_atime].should_not == 0
          lstat[:st_mtime].should_not == 0
          lstat[:st_ctime].should_not == 0
          lstat[:st_atimesec].should_not == 0
          lstat[:st_mtimesec].should_not == 0
          lstat[:st_ctimesec].should_not == 0
        end
      end

      context 'on non-existing file' do
        let(:lstat) { file.lstat }
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
