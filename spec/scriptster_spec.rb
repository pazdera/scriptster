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

require 'stringio'
require 'scriptster'
require 'utils'
require 'tmpdir'

describe Scriptster do
  describe "#log" do
    before :all do
      @out = StringIO.new
      Scriptster::configure do |conf|
        conf.file = @out
      end

      @stdout = StringIO.new
    end

    before :each do
      @out.truncate 0

      @stdout.truncate 0
      @orig_stdout = $stdout
      $stdout = @stdout
    end

    after :each do
      $stdout = @orig_stdout
    end

    it "logs to info" do
      Scriptster::log :info, "Hello there"
      expect(@out.string.strip).to match /info Hello there/
    end

    it "logs to warning" do
      Scriptster::log :warn, "Hello there"
      expect(@out.string.strip).to match /WARN Hello there/
    end

    it "logs to error" do
      Scriptster::log :err, "Hello there"
      expect(@out.string.strip).to match /ERR\! Hello there/
    end

    it "logs to debug" do
      Scriptster::log :debug, "Hello there"
      expect(@out.string.strip).to match /dbg\? Hello there/
    end

    it "raises on bad message type" do
      expect {
        Scriptster::log(:abcd, "Hello there")
      }.to raise_exception ArgumentError
    end

    it "raises on bad verbosity type" do
      expect {
        Scriptster::log(:info, "Hello there", :quiet)
      }.to raise_exception ArgumentError
    end

    it "is quiet" do
      Scriptster::configure do |conf|
        conf.verbosity = :quiet
      end

      Scriptster::log :info, "Hello there"
      expect(@out.string.strip).not_to match /info Hello there/
    end

    it "default verbosity is less than :essential" do
      Scriptster::configure do |conf|
        conf.verbosity = :essential
      end

      Scriptster::log :info, "Hello there"
      expect(@out.string.strip).not_to match /info Hello there/
    end

    it "default verbosity is :informative" do
      Scriptster::configure do |conf|
        conf.verbosity = :informative
      end

      Scriptster::log :info, "Hello there"
      expect(@out.string.strip).to match /info Hello there/
    end
  end

  describe "#cmd" do
    before :all do
      # Set up a temporary test directory
      @dir = Dir.mktmpdir

      File.open("#{@dir}/file.txt", "w") do |f|
        f.puts "Multi-line"
        f.puts "File contents"
      end

      # Set up the dummy stdout/stderr
      @out = StringIO.new
      @err = StringIO.new
    end

    after :all do
      FileUtils.remove_entry_secure @dir
    end

    before :each do
      @out.truncate 0
      @orig_stdout = $stdout
      $stdout = @out

      @err.truncate 0
      @orig_stderr = $stderr
      $stderr = @err
    end

    after :each do
      $stdout = @orig_stdout

      $stderr = @orig_stderr
    end

    it "shows output" do
      Scriptster::cmd "cat #{@dir}/file.txt", :show_out => true

      line1, line2 = remove_colours(@out.string.strip).split "\n"
      expect(line1).to match "Multi-line"
      expect(line2).to match "File contents"
    end

    it "hides output" do
      Scriptster::cmd "cat #{@dir}/file.txt", :show_out => false
      expect(@out.string).to eq ""
    end

    it "captures output" do
      cat = Scriptster::cmd "cat #{@dir}/file.txt", :show_out => false
      expect(cat.out).to eq "Multi-line\nFile contents\n"
    end

    it "shows error" do
      Scriptster::cmd "cat #{@dir}/nonexistent.txt",
        :show_err => true,
        :raise => false

      expect(@out.string.strip).to match "No such file or directory"
    end

    it "hides error" do
      Scriptster::cmd "cat #{@dir}/nonexistent.txt",
        :show_err => false,
        :raise => false

      expect(@out.string.strip).to match ""
    end

    it "captures error" do
      cat = Scriptster::cmd "cat #{@dir}/nonexistent.txt",
        :show_err => true,
        :raise => false

      expect(cat.err.strip).to match "No such file or directory"
    end

    it "collects status (no error)" do
      cat = Scriptster::cmd "cat #{@dir}/file.txt",
        :show_err => true,
        :raise => false

      expect(cat.status.exitstatus).to eq 0
    end

    it "collects status (fail)" do
      cat = Scriptster::cmd "cat #{@dir}/nonexistent.txt",
        :show_err => true,
        :raise => false

      expect(cat.status.exitstatus).to eq 1
    end

    it "does raise" do
      expect {
        Scriptster::cmd "cat #{@dir}/nonexistent.txt"
      }.to raise_exception RuntimeError
    end

    it "expects correct return value" do
        cat = Scriptster::cmd "cat #{@dir}/nonexistent.txt", :expect => 1
        expect(cat.status.exitstatus).to eq 1
    end

    it "expects incorrect return value" do
      expect {
        Scriptster::cmd "cat #{@dir}/nonexistent.txt", :expect => 10
      }.to raise_exception RuntimeError
    end
  end

  describe "#parse_args" do
    before :all do
      doc = <<DOCOPT
Usage: test [-ab]

Options:
-a, --aaa      The first option
-b, --bbb      The second option
DOCOPT

      @args = Scriptster::parse_args doc, ['-a']
    end

    it "returns a Hash" do
      expect(@args).to be_an Hash
    end

    it "the Hash has two keys" do
      expect(@args.length).to be(2)
    end

    it "--aaa is true" do
      expect(@args['--aaa']).to be
    end

    it "--bbb is true" do
      expect(@args['--bbb']).not_to be
    end
  end
end
