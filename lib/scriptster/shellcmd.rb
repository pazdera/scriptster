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

require "open3"
require "tco"

require "scriptster/logger"

module Scriptster
  class ShellCmd
    attr_reader :status, :out, :err

    include Logger

    def initialize(cmd, opts={})
      @out = ""
      @err = ""

      @show_out = false
      @show_err = true
      @raise = true
      @tag = "cmd"
      @expect = 0

      opts.each do |k, v|
        self.instance_variable_set("@#{k.to_s}", v)
      end

      @cmd = cmd
      @status = nil

      run
    end

    private
    def run
      Open3.popen3(@cmd) do |stdin, stdout, stderr, wait_thr|
        stdout_buffer=""
        stderr_buffer=""

        begin
          loop do
            IO.select([stdout,stderr]).flatten.compact.each do |io|
              stdout_buffer += io.readpartial(1) if io.fileno == stdout.fileno
              stderr_buffer += io.readpartial(1) if io.fileno == stderr.fileno
            end
            break if stdout.closed? && stderr.closed?

            # Remove and process all the finished lines from the output buffer
            stdout_buffer.sub!(/.*\n/m) do
              @out += $&
              if @show_out
                $&.strip.split("\n").each do |line|
                  line = tag(@tag, line) if @tag
                  log(:info, line)
                end
              end

              ''
            end

            # Remove and process all the finished lines from the error buffer
            stderr_buffer.sub!(/.*\n/m) do
              @err += $&
              if @show_err
                $&.strip.split("\n").each do |line|
                  line = tag(@tag, line) if @tag
                  log(:err, line)
                end
              end

              ''
            end
          end
        rescue EOFError
          ;
        end

        @status = wait_thr.value
      end

      if (@expect.is_a?(Array) && !@expect.include?(@status.exitstatus)) ||
         (@expect.is_a?(Integer) && @status.exitstatus != @expect)
        unless @show_err
          err_lines = @err.split "\n"
          err_lines.each do |l|
            l = tag(@tag, l.fg("red")) if @tag
            log(:err, l.chomp)
          end
        end
        raise "'#{@cmd}' failed!".fg("red") if @raise
      end
    end
  end
end
