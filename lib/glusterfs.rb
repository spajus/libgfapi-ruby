require "glusterfs/version"
require "glusterfs/file"
require "ffi"

module GlusterFS
  extend FFI::Library

  # https://github.com/gluster/glusterfs/blob/master/api/src/glfs.h
  ffi_lib 'gfapi'

=begin
  SYNOPSIS

  glfs_new: Create a new 'virtual mount' object.

  DESCRIPTION

  This is most likely the very first function you will use. This function
  will create a new glfs_t (virtual mount) object in memory.

  On this newly created glfs_t, you need to be either set a volfile path
  (glfs_set_volfile) or a volfile server (glfs_set_volfile_server).

  The glfs_t object needs to be initialized with glfs_init() before you
  can start issuing file operations on it.

  PARAMETERS

  @volname: Name of the volume. This identifies the server-side volume and
            the fetched volfile (equivalent of --volfile-id command line
      parameter to glusterfsd). When used with glfs_set_volfile() the
      @volname has no effect (except for appearing in log messages).

  RETURN VALUES

  NULL   : Out of memory condition.
  Others : Pointer to the newly created glfs_t virtual mount object.

  glfs_t *glfs_new (const char *volname) __THROW;
=end
  attach_function :new, :glfs_new, [:string], :pointer

=begin
  SYNOPSIS

  glfs_set_volfile: Specify the path to the volume specification file.

  DESCRIPTION

  If you are using a static volume specification file (without dynamic
  volume management abilities from the CLI), then specify the path to
  the volume specification file.

  This is incompatible with glfs_set_volfile_server().

  PARAMETERS

  @fs: The 'virtual mount' object to be configured with the volume
       specification file.

  @volfile: Path to the locally available volume specification file.

  RETURN VALUES

   0 : Success.
  -1 : Failure. @errno will be set with the type of failure.

  int glfs_set_volfile (glfs_t *fs, const char *volfile);
=end
  attach_function :set_volfile, :glfs_set_volfile, [:pointer, :string], :int

=begin
  SYNOPSIS

  glfs_set_volfile_server: Specify the address of management server.

  DESCRIPTION

  This function specifies the address of the management server (glusterd)
  to connect, and establish the volume configuration. The @volname
  parameter passed to glfs_new() is the volume which will be virtually
  mounted as the glfs_t object. All operations performed by the CLI at
  the management server will automatically be reflected in the 'virtual
  mount' object as it maintains a connection to glusterd and polls on
  configuration change notifications.

  This is incompatible with glfs_set_volfile().

  PARAMETERS

  @fs: The 'virtual mount' object to be configured with the volume
       specification file.

  @transport: String specifying the transport used to connect to the
              management daemon. Specifying NULL will result in the usage
        of the default (tcp) transport type. Permitted values
        are those what you specify as transport-type in a volume
        specification file (e.g "tcp", "rdma", "unix".)

  @host: String specifying the address of where to find the management
         daemon. Depending on the transport type this would either be
   an FQDN (e.g: "storage01.company.com"), ASCII encoded IP
   address "192.168.22.1", or a UNIX domain socket path (e.g
   "/tmp/glusterd.socket".)

  @port: The TCP port number where gluster management daemon is listening.
         Specifying 0 uses the default port number GF_DEFAULT_BASE_PORT.
   This parameter is unused if you are using a UNIX domain socket.

  RETURN VALUES

   0 : Success.
  -1 : Failure. @errno will be set with the type of failure.

  int glfs_set_volfile_server (glfs_t *fs, const char *transport,
                               const char *host, int port) __THROW;
=end
  attach_function :set_volfile_server, :glfs_set_volfile_server,
    [:pointer, :string, :string, :int], :int

=begin
  SYNOPSIS

  glfs_set_logging: Specify logging parameters.

  DESCRIPTION

  This function specifies logging parameters for the virtual mount.
  Default log file is /dev/null.

  PARAMETERS

  @fs: The 'virtual mount' object to be configured with the logging parameters.

  @logfile: The logfile to be used for logging. Will be created if it does not
            already exist (provided system permissions allow). If NULL, a new
            logfile will be created in default log directory associated with
            the glusterfs installation.

  @loglevel: Numerical value specifying the degree of verbosity. Higher the
             value, more verbose the logging.

  RETURN VALUES

   0 : Success.
  -1 : Failure. @errno will be set with the type of failure.

  int glfs_set_logging (glfs_t *fs, const char *logfile, int loglevel) __THROW;
=end
  attach_function :set_logging, :glfs_set_logging, [:pointer, :string, :int], :int

=begin
  SYNOPSIS

  glfs_init: Initialize the 'virtual mount'

  DESCRIPTION

  This function initializes the glfs_t object. This consists of many steps:
  - Spawn a poll-loop thread.
  - Establish connection to management daemon and receive volume specification.
  - Construct translator graph and initialize graph.
  - Wait for initialization (connecting to all bricks) to complete.

  PARAMETERS

  @fs: The 'virtual mount' object to be initialized.

  RETURN VALUES

   0 : Success.
  -1 : Failure. @errno will be set with the type of failure.

  int glfs_init (glfs_t *fs) __THROW;
=end
  attach_function :init, :glfs_init, [:pointer], :int

=begin
  SYNOPSIS

  glfs_fini: Cleanup and destroy the 'virtual mount'

  DESCRIPTION

  This function attempts to gracefully destroy glfs_t object. An attempt is
  made to wait for all background processing to complete before returning.

  glfs_fini() must be called after all operations on glfs_t is finished.

  IMPORTANT

  IT IS NECESSARY TO CALL glfs_fini() ON ALL THE INITIALIZED glfs_t
  OBJECTS BEFORE TERMINATING THE PROGRAM. THERE MAY BE CACHED AND
  UNWRITTEN / INCOMPLETE OPERATIONS STILL IN PROGRESS EVEN THOUGH THE
  API CALLS HAVE RETURNED. glfs_fini() WILL WAIT FOR BACKGROUND OPERATIONS
  TO COMPLETE BEFORE RETURNING, THEREBY MAKING IT SAFE FOR THE PROGRAM TO
  EXIT.

  PARAMETERS

  @fs: The 'virtual mount' object to be destroyed.

  RETURN VALUES

   0 : Success.

  int glfs_fini (glfs_t *fs) __THROW;
=end
  attach_function :fini, :glfs_fini, [:pointer], :int

=begin
  PER THREAD IDENTITY MODIFIERS

  The following operations enable to set a per thread identity context
  for the glfs APIs to perform operations as. The calls here are kept as close
  to POSIX equivalents as possible.

  NOTES:

   - setgroups is a per thread setting, hence this is named as fsgroups to be
     close in naming to the fs(u/g)id APIs
   - Typical mode of operation is to set the IDs as required, with the
     supplementary groups being optionally set, make the glfs call and post the
     glfs operation set them back to eu/gid or uid/gid as appropriate to the
     caller
   - The groups once set, need to be unset by setting the size to 0 (in which
     case the list argument is a do not care)
   - Once a process for a thread of operation choses to set the IDs, all glfs
     calls made from that thread would default to the IDs set for the thread.
     As a result use these APIs with care and ensure that the set IDs are
     reverted to global process defaults as required.

  int glfs_setfsuid (uid_t fsuid) __THROW;
  int glfs_setfsgid (gid_t fsgid) __THROW;
  int glfs_setfsgroups (size_t size, const gid_t *list) __THROW;
=end
  attach_function :setfsuid, :glfs_setfsuid, [:int], :int
  attach_function :setfsgid, :glfs_setfsgid, [:int], :int
  attach_function :setfsgroups, :glfs_setfsgroups, [:uint, :pointer], :int

=begin
  SYNOPSIS

  glfs_open: Open a file.

  DESCRIPTION

  This function opens a file on a virtual mount.

  PARAMETERS

  @fs: The 'virtual mount' object to be initialized.

  @path: Path of the file within the virtual mount.

  @flags: Open flags. See open(2). O_CREAT is not supported.
          Use glfs_creat() for creating files.

  RETURN VALUES

  NULL   : Failure. @errno will be set with the type of failure.
  Others : Pointer to the opened glfs_fd_t.

  glfs_fd_t *glfs_open (glfs_t *fs, const char *path, int flags) __THROW;
=end
  attach_function :open, :glfs_open, [:pointer, :string, :int], :pointer

=begin
  SYNOPSIS

  glfs_creat: Create a file.

  DESCRIPTION

  This function opens a file on a virtual mount.

  PARAMETERS

  @fs: The 'virtual mount' object to be initialized.

  @path: Path of the file within the virtual mount.

  @mode: Permission of the file to be created.

  @flags: Create flags. See open(2). O_EXCL is supported.

  RETURN VALUES

  NULL   : Failure. @errno will be set with the type of failure.
  Others : Pointer to the opened glfs_fd_t.

  glfs_fd_t *glfs_creat (glfs_t *fs, const char *path, int flags,
           mode_t mode) __THROW;
=end
  attach_function :creat, :glfs_creat, [:pointer, :string, :int, :int], :pointer

=begin
  int glfs_close (glfs_fd_t *fd) __THROW;
=end
  attach_function :close, :glfs_close, [:pointer], :int

=begin
  // glfs_{read,write}[_async]

  ssize_t glfs_read (glfs_fd_t *fd, void *buf,
                     size_t count, int flags) __THROW;
  ssize_t glfs_write (glfs_fd_t *fd, const void *buf,
                      size_t count, int flags) __THROW;
  int glfs_read_async (glfs_fd_t *fd, void *buf, size_t count, int flags,
           glfs_io_cbk fn, void *data) __THROW;
  int glfs_write_async (glfs_fd_t *fd, const void *buf, size_t count, int flags,
            glfs_io_cbk fn, void *data) __THROW;
=end
  attach_function :read, :glfs_read, [:pointer, :pointer, :uint, :int], :uint
  attach_function :write, :glfs_write, [:pointer, :pointer, :uint, :int], :uint
  # TODO async

=begin
  int glfs_mkdir (glfs_t *fs, const char *path, mode_t mode) __THROW;
=end
  attach_function :mkdir, :glfs_mkdir, [:pointer, :string, :int], :int

=begin
  int glfs_unlink (glfs_t *fs, const char *path) __THROW;
=end
  attach_function :unlink, :glfs_unlink, [:pointer, :string], :int

=begin
  int glfs_rmdir (glfs_t *fs, const char *path) __THROW;
=end
  attach_function :rmdir, :glfs_rmdir, [:pointer, :string], :int

=begin
  int glfs_rename (glfs_t *fs, const char *oldpath, const char *newpath) __THROW;
=end
  attach_function :rename, :glfs_rename, [:pointer, :string, :string], :int

  # TODO the rest

end
