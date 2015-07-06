#!/usr/bin/env ruby

require 'scriptster'

include Scriptster

Scriptster::configure do |conf|
  conf.file = "log.txt"
  conf.verbosity = :verbose
  conf.colours = :dark
  conf.log_format = "%{timestamp} [%{name}] %{type} %{message}"
end

log :info, "Row, row, row your punt", :verbose
log :warn, "Gently down the {{highlight stream}}", :verbose
log :err, "Belts off, trousers down", :verbose
log :debug, "Isn't life a {{highlight scream}}, whoa!", :verbose

cmd "uname -mnrs",
  :show_out => true,
  :show_err => true,
  :expect => 0
