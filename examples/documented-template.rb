#!/usr/bin/env ruby

# Docopt docs:                http://bit.ly/1LT7Rch
# Scriptster::configure docs: http://bit.ly/1H4X3kR
# Scriptster::cmd docs:       http://bit.ly/1LOuVrB

require 'scriptster'
include Scriptster

Scriptster::configure do |conf|
  conf.verbosity = :informative
  conf.log_format = '%{timestamp} [%{name}] %{type} %{message}'
end

args = parse_args <<DOCOPT
Usage:
  #{File.basename __FILE__} [-h] [<dir>]

Options:
  -h, --help          Show this message.
DOCOPT

dir = args['<dir>'] || '~'
log :info, "Listing files in #{dir}:"
ls = cmd "ls -l #{dir} | grep -v '^total'",
  show_out: true,
  out_level: :debug,
  tag: 'ls -l'

files = []
ls.out.lines.each do |line|
  files.push line.split[-1]
end

log :info, files.join(', ')
