#!/usr/bin/env ruby

require 'scriptster'

Scriptster::configure do |conf|
  conf.file = "log.txt"
  conf.verbosity = :verbose
  conf.theme = :dark
  conf.log_format = "%{timestamp} [%{name}] %{type} %{message}"
end

Scriptster::log :info, "Row, row, row your punt", :verbose
Scriptster::log :warn, "Gently down the {{highlight stream}}", :verbose
Scriptster::log :err, "Belts off, trousers down", :verbose
Scriptster::log :debug, "Isn't life a {{highlight scream}}, whoa!", :verbose

Scriptster::cmd "uname -mnrs",
  :show_out => true,
  :show_err => true,
  :expect => 0
