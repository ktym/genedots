#!/usr/bin/env ruby

require 'json'

json = JSON.parse(File.read("../togodx/interaction_number_of_interacting_proteins_uniprot.json"))

json.each do |ensg, list|
  val = list.first["key"].sub("uniprot:", "").to_i - 1
  puts [ensg, val].join("\t")
end

