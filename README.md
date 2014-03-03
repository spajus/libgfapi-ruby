# libgfapi-ruby

Ruby bindings for [libgfapi](https://github.com/gluster/glusterfs/blob/master/api/src/glfs.h)
(GlusterFS API).

## Warning

This library is currently under active development, and is not ready for production yet.

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
file.unlink

# Unmount virtual mount
volume.unmount
```

## Contributing

1. Fork it ( http://github.com/spajus/libgfapi-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
