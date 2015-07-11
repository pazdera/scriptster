#!/usr/bin/env ruby

require 'scriptster'
include Scriptster

args = parse_args <<DOCOPT
Usage:
  #{File.basename __FILE__} [-h]

Options:
  -h, --help          Show this message.
DOCOPT

log :info, "Args received: #{args}"
ls = cmd 'ls', {show_out: true, out_level: :info}
