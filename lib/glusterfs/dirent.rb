class GlusterFS::Dirent < FFI::Struct
  layout :d_ino,       :ino_t,
         :d_off,       :ulong,
         :d_reclen,    :ushort,
         :d_type,      :char,
         :d_name,      :string
end
