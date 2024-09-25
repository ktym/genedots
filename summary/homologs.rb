#!/usr/bin/env ruby
#
# ruby homologs.rb > homologs.tsv 2> homologs.json
# perl -pe 's/\S+\t//' homologs.tsv | s -V | u -c > homologs.dist
# egrep '\t1$' homologs.tsv | cut -f 1 > homologs.1
# egrep '\t1\t2$' homologs.tsv | cut -f 1 | pbcopy
#

require 'json'

json = JSON.parse(File.read("../togodx/gene_ortholog_existence_homologene.json"))

name = {}

json.each do |ensg, list|
  ary = []
  list.each do |hash|
    val = hash["key"].sub("ncbigene:organism_", "").to_i
    ary << val
    name[val] = hash["value"]
  end
  puts [ensg, ary.sort.uniq].join("\t")
end

$stderr.print JSON.pretty_generate(JSON.parse(name.to_json))

