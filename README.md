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

fs = GlusterFS.new 'my_volume'
GlusterFS.set_volfile_server fs, 'tcp', '1.2.3.4', 24007
GlusterFS.init fs
fd = GlusterFS.creat fs, 'my_file', 2, 0755
str = "test data\n"
GlusterFS.write fd, str, str.size + 1, 0
GlusterFS.close fd
```

## Contributing

1. Fork it ( http://github.com/spajus/libgfapi-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
