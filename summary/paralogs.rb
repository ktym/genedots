#!/usr/bin/env ruby

require 'json'

json = JSON.parse(File.read("../togodx/gene_number_of_paralogs_homologene.json"))

json.each do |ensg, list|
  val = list.first["key"].sub("ncbigene:paralog_count_", "").to_i
  puts [ensg, val].join("\t")
end

