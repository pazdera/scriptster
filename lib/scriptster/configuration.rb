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
  # The configuration obejct used in the {Scriptster.configure} method.
  #
  # @attr [String] name  The name of the script to be displayed in the logs.
  # @attr [Symbol] verbosity  The minimum verbosity to of messages to be displayed.
  # @attr [String, File, StringIO] file  A log file that all messages will be written to.
  # @attr [Boolean] timestamps  Include timestamps in log messages.
  # @attr [Symbol, Proc] colours  Desired colour theme (either predefined or custom Proc).
  #                               @see ColourThemes
  # @attr [String] log_format  Template for each line in the logs
  class Configuration
    attr_accessor :name, :verbosity, :file, :colours, :log_format

    def initialize
      @name = File.basename($0)
      @verbosity = :verbose
      @file = nil
      @colours = :dark
      @log_format = "%{timestamp} %{name} %{type} %{message}"
    end

    # Put the settings from this object in effect.
    #
    # This function will distribute the configuration to the
    # appropriate objects and modules.
    def apply
      Logger.set_name @name if @name
      Logger.set_verbosity @verbosity if @verbosity
      Logger.set_file @file if @file
      Logger.set_format @log_format if @log_format

      if @colours.is_a? Proc
        @colours.call
      else
        ColourThemes.send @colours.to_sym
      end
    end
  end

  # A collection of predefined colour settings.
  #
  # It's basically a just configuring the tco library.
  module ColourThemes
    # The colour theme for dark terminals.
    def self.dark
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

    # The colour scheme for dark terminals.
    def self.light
      Tco::configure do |conf|
        conf.names["green"] = "#99ad6a"
        conf.names["yellow"] = "#d8ad4c"
        conf.names["red"] = "#cc333f"
        conf.names["light-grey"] = "#eeeeee"
        conf.names["medium-grey"] = "#cccccc"
        conf.names["dark-grey"] = "#2b2b2b"
        conf.names["purple"] = "#90559e"
        conf.names["blue"] = "#4d9eeb"
        conf.names["orange"] = "#ff842a"

        conf.styles["info"] = {
          :fg => "green", :bg => "default",
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
          :fg => "dark-grey", :bg => "default",
          :bright => false, :underline => false
        }
        conf.styles["debug-message"] = {
          :fg => "medium-grey", :bg => "default",
          :bright => false, :underline => false
        }

        conf.styles["name"] = {
          :fg => "purple", :bg => "light-grey",
          :bright => false, :underline => false
        }
        conf.styles["highlight"] = {
          :fg => "orange", :bg => "default",
          :bright => false, :underline => false
        }
        conf.styles["cmd"] = {
          :fg => "blue", :bg => "light-grey",
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
