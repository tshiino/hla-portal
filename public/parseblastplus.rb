require 'rubygems'
require 'bio'

report = Bio::Blast::Report.new(ARGV)
report.each do |hit|
  p hit.query_seq
  print "\n"
  p hit.midline
  print "\n"
  p hit.target_seq
end
