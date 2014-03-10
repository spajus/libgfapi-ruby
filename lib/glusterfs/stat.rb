class GlusterFS::Stat < FFI::Struct

  S_IFMT   = 0170000  #bit mask for the file type bit fields
  S_IFSOCK = 0140000  #socket
  S_IFLNK  = 0120000  #symbolic link
  S_IFREG  = 0100000  #regular file
  S_IFBLK  = 0060000  #block device
  S_IFDIR  = 0040000  #directory
  S_IFCHR  = 0020000  #character device
  S_IFIFO  = 0010000  #FIFO
  S_ISUID  = 0004000  #set UID bit
  S_ISGID  = 0002000  #set-group-ID bit (see below)
  S_ISVTX  = 0001000  #sticky bit (see below)
  S_IRWXU  = 00700    #mask for file owner permissions
  S_IRUSR  = 00400    #owner has read permission
  S_IWUSR  = 00200    #owner has write permission
  S_IXUSR  = 00100    #owner has execute permission
  S_IRWXG  = 00070    #mask for group permissions
  S_IRGRP  = 00040    #group has read permission
  S_IWGRP  = 00020    #group has write permission
  S_IXGRP  = 00010    #group has execute permission
  S_IRWXO  = 00007    #mask for permissions for others (not in group)
  S_IROTH  = 00004    #others have read permission
  S_IWOTH  = 00002    #others have write permission
  S_IXOTH  = 00001    #others have execute permission

  layout :st_dev,       :dev_t,
         :st_ino,       :ino_t,
         :st_nlink,     :nlink_t,
         :st_mode,      :mode_t,
         :st_uid,       :uid_t,
         :st_gid,       :gid_t,
         :st_rdev,      :dev_t,
         :st_size,      :ulong,
         :st_blksize,   :ulong,
         :st_blocks,    :quad_t,
         :st_atime,     :ulong,
         :st_atimesec,  :ulong,
         :st_mtime,     :ulong,
         :st_mtimesec,  :ulong,
         :st_ctime,     :ulong,
         :st_ctimesec,  :ulong

  def self.dir?(lstat)
    lstat[:st_mode] & S_IFDIR > 0
  end

  def self.file?(lstat)
    lstat[:st_mode] & S_IFREG > 0
  end

  def self.symlink?(lstat)
    lstat[:st_mode] & S_IFLNK > 0
  end

  def to_hash
    {
      :st_dev      => self[:st_dev],
      :st_ino      => self[:st_ino],
      :st_nlink    => self[:st_nlink],
      :st_mode     => self[:st_mode],
      :st_uid      => self[:st_uid],
      :st_gid      => self[:st_gid],
      :st_rdev     => self[:st_rdev],
      :st_size     => self[:st_size],
      :st_blksize  => self[:st_blksize],
      :st_blocks   => self[:st_blocks],
      :st_atime    => self[:st_atime],
      :st_atimesec => self[:st_atimesec],
      :st_mtime    => self[:st_mtime],
      :st_mtimesec => self[:st_mtimesec],
      :st_ctime    => self[:st_ctime],
      :st_ctimesec => self[:st_ctimesec],
    }
  end
end
