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

require "scriptster/logger"
require "scriptster/shellcmd"

module Scriptster
  class Configuration
    attr_writer :name, :verbosity, :file, :timestamps

    def initialize
      @name = File.basename($0)
      @verbosity = :verbose
      @file = nil
      @timestamps = true
      @scheme = :default
    end

    # Put the settings from this object in effect
    def apply
      Logger.set_name @name if @name
      Logger.set_verbosity @verbosity if @verbosity
      Logger.set_file @file if @file
      Logger.show_timestamps if @timestamps

      ColourSchemes.send @scheme
    end
  end

  module ColourSchemes
    def self.default
      Tco::configure do |conf|
        conf.names["green"] = "#99ad6a"
        conf.names["yellow"] = "#d8ad4c"
        conf.names["red"] = "#cc333f"
        conf.names["light-grey"] = "#ababab"
        conf.names["medium-grey"] = "#444444"
        conf.names["dark-grey"] = "#2b2b2b"
        conf.names["purple"] = "#90559e"
        conf.names["blue"] = "#4d9eeb"
        conf.names["orange"] = "#ff842a"

        conf.styles["info"] = {
          :fg => "green", :bg => "dark-grey",
          :bright => false, :underline => false
        }
        conf.styles["info-message"] = {
          :fg => "default", :bg => "default",
          :bright => false, :underline => false
        }

        conf.styles["warn"] = {
          :fg => "dark-grey", :bg => "yellow",
          :bright => false, :underline => false
        }
        conf.styles["warn-message"] = {
          :fg => "default", :bg => "default",
          :bright => false, :underline => false
        }

        conf.styles["err"] = {
          :fg => "dark-grey", :bg => "red",
          :bright => false, :underline => false
        }
        conf.styles["err-message"] = {
          :fg => "default", :bg => "default",
          :bright => false, :underline => false
        }

        conf.styles["debug"] = {
          :fg => "light-grey", :bg => "dark-grey",
          :bright => false, :underline => false
        }
        conf.styles["debug-message"] = {
          :fg => "medium-grey", :bg => "default",
          :bright => false, :underline => false
        }

        conf.styles["name"] = {
          :fg => "purple", :bg => "dark-grey",
          :bright => false, :underline => false
        }
        conf.styles["highlight"] = {
          :fg => "orange", :bg => "default",
          :bright => false, :underline => false
        }
        conf.styles["cmd"] = {
          :fg => "blue", :bg => "dark-grey",
          :bright => false, :underline => false
        }
        conf.styles["timestamp"] = {
          :fg => "medium-grey", :bg => "default",
          :bright => false, :underline => false
        }
      end
    end
  end
end
