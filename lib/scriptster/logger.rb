# scriptster - A small library to make your scipts nicer
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

Tco::configure do |conf|
  conf.names["green"] = "#99ad6a"
  conf.names["yellow"] = "#d8ad4c"
  conf.names["red"] = "#cc333f"
  conf.names["light-grey"] = "#ababab"
  conf.names["dark-grey"] = "#2b2b2b"
  conf.names["purple"] = "#90559e"
  conf.names["blue"] = "#4D9EEB"
  conf.names["orange"] = "#ff842a"
  conf.names["brown"] = "#6a4a3c"

  conf.styles["info"] = {
    :fg => "green",
    :bg => "dark-grey",
    :bright => false,
    :underline => false
  }
  conf.styles["warn"] = {
    :fg => "dark-grey",
    :bg => "yellow",
    :bright => false,
    :underline => false
  }
  conf.styles["err"] = {
    :fg => "dark-grey",
    :bg => "red",
    :bright => false,
    :underline => false
  }
  conf.styles["debug"] = {
    :fg => "light-grey",
    :bg => "dark-grey",
    :bright => false,
    :underline => false
  }

  conf.styles["script-name"] = {
    :fg => "purple",
    :bg => "dark-grey",
    :bright => false,
    :underline => false
  }
end

module Scriptster
  module Logger
    @@script_name = "scriptster"
    @@file = nil
    @@time = false

    @@message_types = {
      :info => "info",
      :warn => "warn",
      :err  => "err",
      :debug => "debug"
    }

    @@verbosity = :verbose
    @@logger_verbosity_levels = {
      :essential => 0,
      :important => 1,
      :informative => 2,
      :verbose => 3
    }

    def self.set_script_name(name)
      @@script_name = name
    end

    def self.set_verbosity(level)
      msg = "Message verbosity level not recognised (#{})."
      raise msg unless @@logger_verbosity_levels.has_key? level.to_sym

      @@verbosity = level.to_sym
    end

    def self.set_file(file)
      @@file.close if @@file
      @@file = File.open file, "w"
    end

    def self.set_time(time_enabled)
      @@time = time_enabled
    end

    def self.log(msg_type, msg, verbosity=nil)
      now = Time.now.strftime "%Y-%m-%d %H-%M "
      out = now + @@script_name.style("script-name") << " "
      file = now + @@script_name + " "

      case msg_type
      when :info
        out << "info".style(@@message_types[:info])
        file << "info"
        verbosity = :informative unless verbosity
      when :warn
        out << "WARN".style(@@message_types[:warn])
        file << "WARN"
        verbosity = :informative unless verbosity
      when :err
        out << "ERR!".style(@@message_types[:err])
        file << "ERR!"
        verbosity = :essential unless verbosity
      when :debug
        out << "dbg?".style(@@message_types[:debug])
        file << "dbg?"
        verbosity = :verbose unless verbosity
      end

      if verbosity <= @@verbosity
        out << " " << msg.chomp
        puts out
        STDOUT.flush

        # Strip colours from the message before writing to a file
        file << " " << msg.chomp.gsub(/\033\[[0-9]+(;[0-9]+){0,2}m/, "")
        @@file.puts file if @@file
      end
    end

    def log(msg_type, msg, verbosity=nil)
      Logger::log msg_type, msg
    end

    def tag(tag, msg)
      tag.fg("blue").bg("dark-grey") << " " << msg
    end
  end
end
