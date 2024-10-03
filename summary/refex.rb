#!/usr/bin/env ruby

require 'json'

json = JSON.parse(File.read("../togodx/gene_high_level_expression_refex.json"))
lang = JSON.parse(File.read("../organs/organs-refex.json"))

translate = {}

lang.each do |hash|
  en = hash["en"]
  ja = hash["ja"]
  translate[en] = ja
end

json.each do |ensg, list|
  list.each do |item|
    organ_en = item["value"]
    organ_ja = translate[organ_en]
    puts [ensg, organ_en, organ_ja].join("\t")
  end
end

