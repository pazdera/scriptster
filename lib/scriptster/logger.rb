# scriptster - A small library to make your scipts a bit nicer
# Copyright (c) 2014 Radek Pazdera

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN


require "tco"

module Scriptster
  # This module contains the logging function and related configuration.
  module Logger
    # The name of the script.
    @@name = nil

    # The IO object to log to.
    @@file = nil

    # Show timestamps flag.
    @@timestamps = false

    # Supported message types.
    @@message_types = {
      :info => "info",
      :warn => "WARN",
      :err  => "ERR!",
      :debug => "dbg?"
    }

    # The default verobosity level.
    @@verbosity = :verbose

    # Supported verbosity levels.
    @@verbosity_levels = {
      :quiet => 0,
      :essential => 1,
      :important => 2,
      :informative => 3,
      :verbose => 4
    }

    @@format = "%{timestamp} %{name} %{type} %{message}"

    # A setter for the script name.
    #
    # @param [String] name  Desired script name.
    def self.set_name(name)
      @@name = name
    end

    # A setter for for logger verbosity.
    #
    # @param [Symbol] level  Desired verbosity level.
    def self.set_verbosity(level)
      msg = "Message verbosity level not recognised (#{})."
      raise msg unless @@verbosity_levels.has_key? level.to_sym

      @@verbosity = level.to_sym
    end

    # A setter for the log file.
    #
    # @param [String, StringIO, File] file  A path or an IO object.
    def self.set_file(file)
      @@file.close if @@file
      @@file = nil

      case
        when file.is_a?(String) then @@file = File.open file, "w"
        when file.is_a?(File) then @@file = file
        when file.is_a?(StringIO) then @@file = file
        else
          raise "Not a vailid file"
      end
    end

    # Specify the format of each line in the logs.
    #
    # The template can reference the following keys:
    #   * timestamp
    #   * name
    #   * type
    #   * message
    #
    # @example
    #   Logger::set_format "%{timestamp} %{name} %{type} %{message}"
    #
    # @param [String] format  The format template.
    def self.set_format(format)
      @@format = format
    end

    # Log a string.
    #
    # The message will be written to both stdout and the log file if configured.
    #
    # @param [Symbol] msg_type  Type of the message.
    # @param [String] msg  The contents of the log message.
    # @param [Symbol] verbosity  Desired verbosity level of this message.
    def self.log(msg_type, msg, verbosity=:informative)
      # arguments sanity checks
      unless @@message_types.include? msg_type
        raise ArgumentError, "Unknown message type :#{msg_type}"
      end

      unless @@verbosity_levels.include?(verbosity) and verbosity != :quiet
        raise ArgumentError, "You can't use the :#{verbosity.to_s} verbosity level"
      end

      if @@verbosity_levels[verbosity] <= @@verbosity_levels[@@verbosity]
          ts = Time.now.strftime("%Y-%m-%d %H:%M:%S").style("timestamp")

        name = if @@name != nil && @@name.length > 0
          @@name.style("name")
        else
          ""
        end

        msg.chomp!
        msg = Tco::parse msg, Tco::get_style("#{msg_type.to_s}-message")

        line = @@format % {
          timestamp: ts,
          name: name,
          type: @@message_types[msg_type].style(msg_type.to_s),
          message: msg
        }

        puts line
        STDOUT.flush

        if @@file
          # Strip colours from the message before writing to a file
          @@file.puts line.gsub(/\033\[[0-9]+(;[0-9]+){0,2}m/, "")
        end
      end
    end

    # Instance method wrapper for when the module is included.
    #
    # @see Logger.log
    def log(msg_type, msg, verbosity=:informative)
      Logger::log msg_type, msg, verbosity
    end
  end
end
