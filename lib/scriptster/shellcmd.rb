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
  # Represent an executed shell command.
  #
  # The command will be executed in the constructor. It runs in the
  # foreground, so your application will block until it's finished
  # executing. The logs, however, will be printed real-time as the
  # command prints its output.
  #
  # @attr [Process::status] status  The exit status of the command.
  # @attr [String] out  The content of the STDOUT of the command.
  # @attr [String] err  The content of the STDERR of the command.
  class ShellCmd
    attr_reader :status, :out, :err

    include Logger

    # Initialise the object and run the command
    #
    # @param [String] cmd  The command line to be run.
    # @param [Hash] opts  Various options of the command.
    # @option opts [Boolean] :show_out  Care about STDOUT flag.
    # @option opts [Boolean] :out_level To which log level to print the output
    #                                   [default: :info].
    # @option opts [Boolean] :show_err  Care about STDERR flag.
    # @option opts [Boolean] :raise  Raise on error flag.
    # @option opts [String] :tag  Logger tag (defaults to the first
    #                             word of the command line).
    # @option opts [Integer, Array<Integer>] :expect  Expected return values.
    def initialize(cmd, opts={})
      @out = ""
      @err = ""

      @show_out = false
      @out_level = :info
      @show_err = true
      @raise = true
      @tag = cmd.split[0]
      @expect = 0

      opts.each do |k, v|
        self.instance_variable_set("@#{k.to_s}", v)
      end

      @cmd = cmd
      @status = nil

      run
    end

    private
    # Execute the command and collect all the data from it.
    #
    # The function will block until the command has finished.
    def run
      Open3.popen3(@cmd) do |stdin, stdout, stderr, wait_thr|
        stdout_buffer=""
        stderr_buffer=""

        streams = [stdout, stderr]
        while streams.length > 0
          IO.select(streams).flatten.compact.each do |io|
            if io.eof?
              streams.delete io
              next
            end

            stdout_buffer += io.readpartial(1) if io.fileno == stdout.fileno
            stderr_buffer += io.readpartial(1) if io.fileno == stderr.fileno
          end

          # Remove and process all the finished lines from the output buffer
          stdout_buffer.sub!(/.*\n/m) do
            @out += $&
            if @show_out
              $&.strip.split("\n").each do |line|
                line = @tag.style("cmd") + " " + line if @tag
                log(@out_level, line)
              end
            end

            ''
          end

          # Remove and process all the finished lines from the error buffer
          stderr_buffer.sub!(/.*\n/m) do
            @err += $&
            if @show_err
              $&.strip.split("\n").each do |line|
                line = @tag.style("cmd") + " " + line if @tag
                log(:err, line)
              end
            end

            ''
          end
        end

        @status = wait_thr.value
      end

      if (@expect.is_a?(Array) && !@expect.include?(@status.exitstatus)) ||
         (@expect.is_a?(Integer) && @status.exitstatus != @expect)
        unless @show_err
          err_lines = @err.split "\n"
          err_lines.each do |l|
            l = @tag.style("cmd") + " " + l if @tag
            log(:err, l.chomp)
          end
        end
        raise "'#{@cmd}' failed!" if @raise
      end
    end
  end
end
