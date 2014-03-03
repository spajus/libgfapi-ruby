# libgfapi-ruby

Ruby bindings for [libgfapi](https://github.com/gluster/glusterfs/blob/master/api/src/glfs.h)
(GlusterFS API).

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
fs = GlusterFS.new 'my_volume'
GlusterFS.set_volfile_server fs, 'tcp', '1.2.3.4', 24007
GlusterFS.init fs

# Make a new directory
GlusterFS.mkdir fs, '/some_dir', 0755

# Write a file
fd = GlusterFS.creat fs, '/somedir/my_file', 2, 0755
str = "test data\n"
GlusterFS.write fd, str, str.size + 1, 0
GlusterFS.close fd

# Destroy virtual mount
GlusterFS.fini fs
```

## Contributing

1. Fork it ( http://github.com/spajus/libgfapi-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
