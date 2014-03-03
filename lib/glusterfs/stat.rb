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
end
