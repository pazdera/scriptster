#!/usr/bin/env ruby

# Docopt docs:                http://bit.ly/1LT7Rch
# Scriptster::configure docs: http://bit.ly/1H4X3kR
# Scriptster::cmd docs:       http://bit.ly/1LOuVrB

require 'docopt'
require 'scriptster'

include Scriptster

doc = <<DOCOPT
Usage:
  #{File.basename __FILE__} [-h]

Options:
  -h, --help          Show this message.
DOCOPT

Scriptster::configure do |conf|
  conf.verbosity = :verbose
  conf.log_format = '%{timestamp} [%{name}] %{type} %{message}'
end

begin
  args = Docopt::docopt doc
rescue Docopt::Exit => e
  log :err, e.message
  exit 1
end

### >>> Example
log :info, "Listing files:"
ls = cmd 'ls -l | grep -v "^total"',
  show_out: true,
  show_err: true,
  tag: 'ls -l'

files = []
ls.out.lines.each do |line|
  files.push line.split[-1]
end

log :info, files.join(', ')
# <<<
