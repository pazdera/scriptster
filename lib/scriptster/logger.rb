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
  module Logger
    @@name = nil
    @@file = nil
    @@timestamps = false

    @@message_types = {
      :info => "info",
      :warn => "WARN",
      :err  => "ERR!",
      :debug => "dbg?"
    }

    @@verbosity = :verbose
    @@verbosity_levels = {
      :quiet => 0,
      :essential => 1,
      :important => 2,
      :informative => 3,
      :verbose => 4
    }

    def self.set_name(name)
      @@name = name
    end

    def self.set_verbosity(level)
      msg = "Message verbosity level not recognised (#{})."
      raise msg unless @@verbosity_levels.has_key? level.to_sym

      @@verbosity = level.to_sym
    end

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

    def self.show_timestamps
      @@timestamps = true
    end

    def self.log(msg_type, msg, verbosity=:informative)
      if @@verbosity_levels[verbosity] <= @@verbosity_levels[@@verbosity]
        ts = if @@timestamps
          Time.now.strftime("%Y-%m-%d %H:%M").style("timestamp") + " "
        else
          ""
        end

        name = if @@name != nil && @@name.length > 0
          @@name.style("name") + " "
        else
          ""
        end

        msg.chomp!
        msg = Tco::parse msg, Tco::get_style("#{msg_type.to_s}-message")

        line = ts << name.style("name") <<
               @@message_types[msg_type].style(msg_type.to_s) <<
               " " << msg
        puts line
        STDOUT.flush

        if @@file
          # Strip colours from the message before writing to a file
          @@file.puts line.gsub(/\033\[[0-9]+(;[0-9]+){0,2}m/, "")
        end
      end
    end

    def log(msg_type, msg, verbosity=:informative)
      Logger::log msg_type, msg, verbosity
    end
  end
end
