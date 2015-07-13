#!/usr/bin/env ruby

# Docopt docs:                http://bit.ly/1LT7Rch
# Scriptster::configure docs: http://bit.ly/1H4X3kR
# Scriptster::cmd docs:       http://bit.ly/1LOuVrB

require 'scriptster'
include Scriptster

Scriptster::configure do |conf|
  # Which log levels will be printed
  # (one of :quiet, :essential, :important, :informative or :verbose)
  conf.verbosity = :informative

  # Customise the log line format
  conf.log_format = '%{timestamp} [%{name}] %{type} %{message}'

  # Save the logs into a file
  conf.file = "/tmp/lsl-log"

  # Either :light or :dark.
  conf.colours = :dark
end

args = parse_args <<DOCOPT
Usage:
  #{File.basename __FILE__} [-h] [<dir>]
  #{File.basename __FILE__} -a

Options:
  -a, --aaa           Option description
  -h, --help          Show this message.
DOCOPT

log :warn, "There are four logging levels (:error, :warn, :info and :debug)"

dir = args['<dir>'] || '~'
log :info, "Listing files in #{dir}"
ls = cmd "ls -l #{dir} | grep -v '^total'",
  show_out: true,     # print stdout as the command runs
  show_err: true,     # print stderr
  out_level: :debug,  # which log level to print the output to
  tag: 'ls -l',       # modify the default command tag
  expect: 0,          # the expected return status (can be an Array as well)
  raise: true         # raise if the command exits with an unexpected code

# Iterate through stdout (the same can be done for stderr with .err)
files = []
ls.out.lines.each do |line|
  files.push line.split[-1]
end
log :info, files.join(', ')

# Get information about the process
log :info, "ls(#{ls.status.pid}) exited with #{ls.status.exitstatus}"
