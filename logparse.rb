# -*- coding: utf-8 -*-
require 'date'

target_dir = ARGV[0]
ex_dir = "export"

def conv_date(str)
  (DateTime.parse(str) + Rational(9, 24)).strftime("%Y-%m-%d %X")
end

def conv_file(fr, fw)
  s = "any string"
  d = /^(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)/

  fr.each_line do |line|
    if /[GET|POST|PUT|DELETE] #{s}/ =~ line then
      line.match(d) do |md|
        fw.write(line.sub(d, conv_date(md.to_s)))
      end
    end
  end
end

Dir.chdir(target_dir) do
  Dir.mkdir(ex_dir) if !Dir.exist?(ex_dir)

  Dir.glob("*.log").each do |log|
    File.open(log, "r") do |fr|
      File.open("#{ex_dir}/ex_#{log}", "w") do |fw|
        conv_file(fr, fw)
      end
    end
  end
end
