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

require "scriptster/version"
require "scriptster/logger"
require "scriptster/shellcmd"
require "scriptster/configuration"

# The public interface of scriptster is simple. It consists of two
# functions, cmd and log. The module can be used directly or included
# in your class.
module Scriptster
  # Pass a message to the logger.
  #
  # @see Logger.log
  def self.log(*args)
    Logger::log *args
  end

  # The same as {Scriptster.log}.
  #
  # @see .log
  def log(*args)
    self.log *args
  end

  # Execute a shell command
  #
  # @see ShellCmd
  def self.cmd(*args)
    ShellCmd.new *args
  end

  # The same as {Scriptster.cmd}.
  #
  # @see .cmd
  def cmd(*args)
    self.cmd *args
  end

  # Use this method to reconfigure the library.
  #
  # @example
  #   Scriptster::configure do |conf|
  #     conf.name = "my-script"
  #     conf.colours = :light
  #     conf.timestamps = false
  #   end
  #
  # @yield [c] An instance of the {Configuration} class.
  # @see Configuration
  def self.configure
    c = Configuration.new
    yield c
    c.apply
  end
end
