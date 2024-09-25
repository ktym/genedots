#!/usr/bin/env ruby
#
# bin/mart_export2json_ext.rb ensembl/mart_export.txt > genedots.json
#

require 'json'

homologs = {}
homolog_orgs = JSON.parse(File.read("summary/homologs.json"))

File.open("summary/homologs.tsv").each do |line|
  ary = line.strip.split
  # oldest organism having a homologous gene
  homologs[ary.first] = ary.last
end

paralogs = {}

File.open("summary/paralogs.tsv").each do |line|
  ary = line.strip.split
  # number of paralogous genes
  paralogs[ary.first] = ary.last
end

ppi = {}

File.open("summary/ppi.tsv").each do |line|
  ary = line.strip.split
  # number of interacting proteins
  ppi[ary.first] = ary.last
end

disease = {}

File.open("summary/disease.tsv").each do |line|
  ary = line.strip.split
  # number of variants reported in ClinVar for this gene
  disease[ary.first] = ary.last
end

variants = {}
pathogenic = {}

File.open("summary/pathogenic.tsv").each do |line|
  ary = line.strip.split
  # number of variants reported in ClinVar for this gene
  variants[ary.first] = ary.last
  # existence of (likely) pathogenic variant in this gene
  if ary[1] == "true"
    pathogenic[ary.first] = true
  end
end


# ["Gene stable ID", "Gene start (bp)", "Gene end (bp)", "Strand", "Karyotype band", "Chromosome/scaffold name", "HGNC ID", "HGNC symbol", "UniProtKB/Swiss-Prot ID"]

head = ARGF.gets.chomp.split(/\t/)

chrs = ("1".."22").to_a + %w(X Y MT)
memo = {}

ary = []

ARGF.each do |line|
  ensg, from, to, str, band, chr, hgnc_id, hgnc, up = line.chomp.split(/\t/)
  next unless chrs.include?(chr)
  next unless up
  # to ensure only one record for each gene to be included
  if memo[hgnc]
    next
  else
    memo[hgnc] = true
  end
  hash = {
    :hgnc => hgnc,
    :hgnc_id => hgnc_id ? hgnc_id.downcase : "",
    :chr => chr,
    :chr_sort => chrs.index(chr) + 1,
    :pos => from.to_i,
    :len => to.to_i - from.to_i + 1,
    :str => str.to_i,
    :band => band,
    :ensg => ensg,
    :up => up,
    :homolog => homologs[ensg].to_i,
    :homolog_org => homolog_orgs[homologs[ensg].to_s],
    :paralog => paralogs[ensg].to_i,
    :ppi => ppi[ensg].to_i,
    :clinvar => variants[ensg].to_i,
  }
  if pathogenic[ensg]
    hash[:pathogenic] = true
  end
  if disease[ensg].to_i > 0
    hash[:disease] = disease[ensg].to_i
  end
  ary.push(hash)
end

selected = []

ary.sort_by {|x| [ x[:chr_sort], x[:pos] ] }.each_with_index do |x, i|
  x[:id] = i + 1
  selected.push(x)
end

puts selected.to_json

