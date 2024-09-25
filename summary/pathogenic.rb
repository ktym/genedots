#!/usr/bin/env ruby
#
# ruby pathogenic.rb > pathogenic.tsv
# cut -f 2 pathogenic.tsv | s | u -c > pathogenic.dist
#

require 'json'

json = JSON.parse(File.read("../togodx/variant_clinical_significance_togovar.json"))

name = {}

json.each do |ensg, list|
  ary = []
  val = false
  list.each do |hash|
    if hash["value"][/pathogenic/i]
      val = true
    end
    ary << hash["key"]
  end
  # existense of (Likely) Pathogenic variants and number of variant annotations in ClinVar for this gene
  puts [ensg, val, ary.size].join("\t")
end


