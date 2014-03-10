class GlusterFS::Stat < FFI::Struct
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
