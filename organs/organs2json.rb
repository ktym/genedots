#!/usr/bin/env ruby

require 'json'

ary = []

ARGF.gets

ARGF.each do |line|
  en, ja = line.split(/\t/)
  ary << { "en" => en.strip, "ja" => ja.strip }
end

puts ary.to_json

