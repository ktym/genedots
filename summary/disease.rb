#!/usr/bin/env ruby
#
# ruby disease.rb > disease.tsv
# cut -f 2 disease.tsv | s | u -c > disease.dist
#

require 'json'

json = JSON.parse(File.read("../togodx/disease_diseases_mondo-c__0700096.json"))

name = {}

json.each do |ensg, list|
  ary = []
  list.each do |hash|
    ary << hash["key"]
  end
  # number of diseases related to this gene
  puts [ensg, ary.size].join("\t") if ary.size > 0
end


