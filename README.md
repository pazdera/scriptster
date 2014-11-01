# Scriptster

[![Gem Version](https://badge.fury.io/rb/scriptster.png)](http://badge.fury.io/rb/scriptster)
[![Inline docs](http://inch-ci.org/github/pazdera/scriptster.png)](http://inch-ci.org/github/pazdera/scriptster)
[![Build Status](https://travis-ci.org/pazdera/scriptster.svg)](https://travis-ci.org/pazdera/scriptster)

Scriptster is a small Ruby gem that will help you write scripts in Ruby. It
only consists of two functions and it's especially useful for apps
which depend on many external tools.

<img alt="Example output"
     src="http://broken.build/assets/images/posts/scriptster-example.png"
     style="width:400px;">

This library focuses on these two basic things:
 * Running shell commands
 * Providing nice logs and status messages about what happened

See the examples bellow.

## Usage

```ruby
require 'scriptster'
```

It's not necessary to configure scriptster before using it, if you're happy
with the default settings. But chances are you won't be, in which case the
`configure` method is exactly what you're after. Bellow is a quick example
(for the full list of options, please refer to the
[docs](http://www.rubydoc.info/github/pazdera/scriptster/master/frames)):

```ruby
Scriptster::configure do |conf|
  conf.name = "my-script"
  conf.verbosity = :verbose
  conf.file = nil
  conf.colours = :dark
  conf.log_format = "%{timestamp} %{name} %{type} %{message}"
end
```

The following snippet demonstrates how can you use **scriptster**
in practice:

```ruby
Scriptster::log :info, "Checking branches"

git_cmd = Scriptster::cmd.new "git branch",
  :show_out = true,
  :show_err = true

branch_exists = git_cmd.out.split("\n").grep(/#{branch}/).length > 0
Scriptster::log(:warn, "Branch '#{branch}' not found") unless branch_exists
```

The first `log` method will format and print a status message to stdout.
The latter `cmd` method executes the given `git` command, prints it's
output, but it also keeps it for processing. You will find more about
the options and parameters of these functions in the
[documentation](http://www.rubydoc.info/github/pazdera/scriptster/master/frames).

## Installation

Add this line to your application's Gemfile:

    gem 'scriptster'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scriptster


## Contributing

1. Fork it ( https://github.com/[my-github-username]/scriptster/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
