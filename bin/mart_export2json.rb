#!/usr/bin/env ruby

require 'json'

head = ARGF.gets.chomp.split(/\t/)

# ["Gene stable ID", "Gene start (bp)", "Gene end (bp)", "Strand", "Karyotype band", "Chromosome/scaffold name", "HGNC ID", "HGNC symbol", "UniProtKB/Swiss-Prot ID"]

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
    :up => up
  }
  ary.push(hash)
end

selected = []

ary.sort_by {|x| [ x[:chr_sort], x[:pos] ] }.each_with_index do |x, i|
  x[:id] = i + 1
  selected.push(x)
end

puts selected.to_json

