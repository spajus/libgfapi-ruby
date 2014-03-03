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
volume =  GlusterFS::Client.mount('my_volume', '1.2.3.4')

# Make a new directory (raw)
GlusterFS.mkdir(volume.fs, '/some_dir', 0755)

# Write a file
file = GlusterFS::File.new(volume, '/gfs/file/path')
size = file.write(data)
puts "Written #{size} bytes"

# Read a file
file = GlusterFS::File.new(volume, '/gfs/file/path')
contents = file.read
contents = file.read

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
