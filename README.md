# libgfapi-ruby

Ruby bindings for [libgfapi](https://github.com/gluster/glusterfs/blob/master/api/src/glfs.h)
(GlusterFS API).

[![Gem Version](https://badge.fury.io/rb/libgfapi-ruby.png)](http://badge.fury.io/rb/libgfapi-ruby)
[![Code Climate](https://codeclimate.com/github/spajus/libgfapi-ruby.png?branch=master)](https://codeclimate.com/github/spajus/libgfapi-ruby)
[![Dependency Status](https://gemnasium.com/spajus/libgfapi-ruby.png?branch=master)](https://gemnasium.com/spajus/libgfapi-ruby)


## Installation

Add this line to your application's Gemfile:

    gem 'libgfapi-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libgfapi-ruby

## Usage

```ruby
require 'glusterfs'

# Create virtual mount
volume = GlusterFS::Volume.new('my_volume')
volume.mount('1.2.3.4')

# Create a new directory
dir = GlusterFS::Directory.new(volume, '/some_dir')
dir.create

# Delete a directory
dir = GlusterDS::Directory.new(volume, '/some_dir')
dir.delete
# or
volume.delete_dir('/some_dir')

# Create a file from string or bytes
file = GlusterFS::File.new(volume, '/gfs/file/path')
size = file.write(data)
puts "Written #{size} bytes"

# Copy an existing file to gluster
existing_file = File.open('/path/to/file')
file = GlusterFS::File.new(volume, '/gfs/file/path')
size = file.write_file(existing_file)
puts "Written #{size} bytes"

# Read a file
file = GlusterFS::File.new(volume, '/gfs/file/path')
contents = file.read

# Read a file into a Tempfile
file = GlusterFS::File.new(volume, '/gfs/file/path')
tempfile = file.read_file
puts "Tempfile path: #{tempfile.path}"

# Delete a file
file = GlusterFS::File.new(volume, '/gfs/file/path')
file.delete
# or
volume.delete_file('/gfs/file/path')

# Unmount virtual mount
volume.unmount
```

## Running Specs

Run specs with `rake spec`. However, you need glusterfs-server running somewhere, and a test mount.
If you have it in the computer you want to run your tests at (Vagrant works fine), you can do this:

1. Add `127.0.0.1 distfs` to `/etc/hosts`
2. Run `gluster volume create dist-volume distfs:/dist1 force`
3. Run `gluster volume start dist-volume`
4. Run `rake spec`

Another option - use existing cluster, set following env variables before running tests:

```bash
export GFS_VOLUME='volume-name'
export GFS_SERVER_HOST='1.2.3.4'
export GFS_SERVER_PORT=24007
rake spec
```

## Performance

There is performance spec: `spec/glusterfs/stress/performance_spec.rb`. You can edit values at
`spec/spec_helper.rb` or provide ENV variables to run it on your system. Here's how 1000 iterations
of create/delete directories with various file sizes looks like:

```
# 5 Kb files
Native FS Time:  1000 iterations:  0.1400 sec
Mounted FS Time: 1000 iterations: 44.0874 sec
GFS API Time:    1000 iterations: 42.4865 sec

# 70 Kb files
Native FS Time:  1000 iterations:  0.6270 sec
Mounted FS Time: 1000 iterations: 79.2414 sec
GFS API Time:    1000 iterations: 46.4481 sec

# 5 Mb files
Native FS Time:  1000 iterations:   6.1057 sec
Mounted FS Time: 1000 iterations:  94.8507 sec
GFS API Time:    1000 iterations: 118.8812 sec
```

Tests were run on CentOS with Intel(R) Xeon(R) CPU E5-2407 0 @ 2.20GHz, 128GB RAM, with following
GlusterFS Volume configuration:

```
Volume Name: dist-volume
Type: Replicate
Volume ID: <skipped>
Status: Started
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: server1:/var/lib/gfs/dist-volume
Brick2: server2:/var/lib/gfs/dist-volume
Options Reconfigured:
server.allow-insecure: on
features.worm: disable
network.frame-timeout: 10
diagnostics.latency-measurement: on
performance.cache-size: 1024MB
cluster.data-self-heal-algorithm: full
nfs.disable: yes
performance.write-behind-window-size: 128MB
performance.cache-refresh-timeout: 10
```

## TODO

Major things missing:
- Directory listing / traversal

## Known issues

`GlusterFS::Volume.mount / unmount` [leaks
memory](https://bugzilla.redhat.com/show_bug.cgi?id=1072854).

## Contributing

1. Fork it ( http://github.com/spajus/libgfapi-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
