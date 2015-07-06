#!/usr/bin/env ruby

require 'scriptster'

Scriptster::configure do |conf|
  conf.verbosity = :verbose
  conf.log_format = "%{name} %{type}  %{message}"
  conf.colours = Proc.new do
    Tco::configure do |conf|
      conf.names["red"] = "#BF0C43" #"DF151A"
      conf.names["orange"] = "#F9BA15" #"FD8603"
      conf.names["yellow"] = "#8EAC00" #"F4F328"
      conf.names["green"] = "#127A97" #"00DA3C"
      conf.names["blue"] = "#452B72" #"00CBE7"

      conf.names["light-grey"] = "#ababab"
      conf.names["medium-grey"] = "#444444"
      conf.names["dark-grey"] = "#2b2b2b"

      conf.styles["info"] = {
        :fg => "dark-grey", :bg => "green",
        :bright => false, :underline => false
      }
      conf.styles["info-message"] = {
        :fg => "default", :bg => "default",
        :bright => false, :underline => false
      }

      conf.styles["warn"] = {
        :fg => "dark-grey", :bg => "orange",
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
        :fg => "#000", :bg => "blue",
        :bright => false, :underline => false
      }
      conf.styles["debug-message"] = {
        :fg => "default", :bg => "default",
        :bright => false, :underline => false
      }

      conf.styles["name"] = {
        :fg => "medium-grey", :bg => "default",
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

Scriptster::log :err,   "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :err,   "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :warn,  "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :warn,  "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :info,  "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :info,  "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :debug, "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
Scriptster::log :debug, "{{red:: These}} {{orange:: logs}} {{yellow:: are}} {{green:: pretty}} {{blue:: funky.}}"
