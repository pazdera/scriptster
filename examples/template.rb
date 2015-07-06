#!/usr/bin/env ruby

# Docopt docs:                http://bit.ly/1LT7Rch
# Scriptster::configure docs: http://bit.ly/1H4X3kR
# Scriptster::cmd docs:       http://bit.ly/1LOuVrB

require 'docopt'
require 'scriptster'

doc = <<DOCOPT
Usage:
  #{File.basename __FILE__} [-h]

Options:
  -h, --help          Show this message.
DOCOPT

begin
  args = Docopt::docopt doc
rescue Docopt::Exit => e
  $stderr.puts e.message
  exit 1
end

Scriptster::configure do |conf|
  conf.verbosity = :verbose
  conf.log_format = '%{timestamp} [%{name}] %{type} %{message}'
end

### >>> Example
Scriptster::log :info, "Started!"
ls = Scriptster::cmd 'ls -l | grep -v "^total"',
  show_out: true,
  show_err: true,
  tag: 'ls -l'

files = []
ls.out.lines.each do |line|
  files.push line.split[-1]
end

Scriptster::log :info, files.join(', ')
# <<<
