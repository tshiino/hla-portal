#!/usr/bin/env ruby

require 'bio'

class Bio::Sequence::NA
  def detectins
    targetseq = self
    i = 0
    inserts = Array.new  # list of insert position [[1st, last], ...]
    while i <= targetseq.length
      p = targetseq.index(/(-+)/, i)
      break if p == nil
      l = $1.length
      foundins = [p+1, p+l]  # [1st, last] positions of inserts found.
      inserts.push(foundins)
      p $1
      print "\n"
      i = p + l
    end
    return inserts
  end

  def correctins(cs)
    # cs: codon_start
    cs -= 1
    targetseq = self
    joinflag = false
    inserts = targetseq.detectins
    inserts.each do |sp, ep|
      staddr = sp - 1
      edaddr = ep - 1
      if joinflag == true
        joinflag = false
        next
      end
      len = edaddr - staddr + 1
      cop = (staddr - cs).modulo(3)  # position in codon 0 or 1 or 2
      case len
      when 1
        if targetseq[edaddr + 2] == '-' && targetseq[edaddr + 3] == '-' && targetseq[edaddr + 4] != '-'
          joinflag = true
          case cop
          when 0 # The insert matches codon frame.
            targetseq[staddr + 3] = targetseq[staddr + 1]
            targetseq[staddr + 1] = '-'
          when 1 # The insert starts from codon 2.
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 1] = targetseq[staddr + 4]
            targetseq[staddr + 4] = '-'
          when 2 # The insert starts from codon 3.
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 1] = '-'
          end
        elsif targetseq[edaddr + 3] == '-' && targetseq[edaddr + 4] == '-' && targetseq[edaddr + 5] != '-'
          joinflag = true
          case cop
          when 0 # The insert matches codon frame.
            targetseq[staddr + 3] = targetseq[staddr + 1]
            targetseq[staddr + 4] = targetseq[staddr + 2]
            targetseq[staddr + 1] = '-'
            targetseq[staddr + 2] = '-'
          when 1 # The insert starts from codon 2.
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 1] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          when 2 # The insert starts from codon 3.
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 4] = targetseq[staddr + 2]
            targetseq[staddr + 1] = '-'
            targetseq[edaddr + 2] = '-'
          end
        end
      when 2
        if targetseq[edaddr + 2] == '-' && targetseq[edaddr + 3] != '-'
          joinflag = true
          case cop
          when 0 # The insert matches codon frame.
            targetseq[staddr + 3] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          when 1 # The insert starts from codon 2.
            targetseq[staddr + 3] = targetseq[staddr + 2]
            targetseq[staddr + 2] = targetseq[staddr - 1]
            targetseq[staddr - 1] = '-'
          when 2 # The insert starts from codon 3.
            targetseq[staddr] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          end
        elsif targetseq[edaddr + 3] == '-' && targetseq[edaddr + 4] != '-'
          joinflag = true
          case cop
          when 0 # The insert matches codon frame.
            targetseq[staddr + 4] = targetseq[staddr + 3]
            targetseq[staddr + 3] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          when 1 # The insert starts from codon 2.
            targetseq[staddr] = targetseq[staddr + 2]
            targetseq[staddr + 1] = targetseq[staddr + 3]
            targetseq[staddr + 2] = '-'
            targetseq[staddr + 3] = '-'
          when 2 # The insert starts from codon 3.
            targetseq[staddr] = targetseq[staddr + 2]
            targetseq[staddr + 4] = targetseq[staddr + 3]
            targetseq[staddr + 2] = '-'
            targetseq[staddr + 3] = '-'
          end
        end
      when 3
        case cop
        when 1 # The insert starts from codon 2.
          targetseq[edaddr] = targetseq[staddr - 1]
          targetseq[staddr - 1] = '-'
        when 2 # The insert starts from codon 3.
          targetseq[staddr] = targetseq[edaddr + 1]
          targetseq[edaddr + 1] = '-'
        else # The insert matches codon frame.
          next
        end
      else
      end
    end
    return targetseq
  end
end

factory = Bio::Blast.local('blastn', 'HXB2nucDB')
factorf = Bio::Fasta.local('fasta34', './HXB2-DNAs.fas', option = '-b 8')

seq = Bio::Sequence::NA.new("CCTCAAATCACTCTTTGGCAGCGACCCCTCGTTGCAATAAAGATAGGGGGGCAGCTAAAGGAAGCTCTATTAGATACAGGAGCAGATGATACAGTATTAGAAGAAATGAATTTAACAGGGAAATGGAAACCAAAAATGATAGGGGGAATTGGAGGTTTTATCAAAGTGAAACAGTATGATCAGGTAGCTATAGAAATCTGTGGACATAAAGTTACAGGTACAGTATTAGTAGGACCCACACCTGTCAATATAATTGGAAGGAATCTGTTGACTCAGCTTGGCTGCACTTTAAATTTTCCCATTAGTCCTATTGAAACTGTACCAGTAAAATTAAAGCCAGGAATGGATGGCCCAAAAGTAAAACAATGGCCATTGACAGAAGAAAAAATAAAAGCATTAATAGAAATTTGCACAGAAATGGAAAAGGAAGGGAAAATTTCAAAAATTGGGCCTGAAAATCCATACAATACTCCAGTGTTTGCAATAAAGAAGAAAGACAGTACTAAATGGAGAAAATTAGTAGATTTCAGAGAACTTAATAAAAGGACTCAAGACTTCTGGGAAGTTCAATTAGGAATACCACATCCTGCAGGGTTAAAAAAGAAAAAATCAGTAACAGTACTGGATGTGGGTGATGCATATTTTTCAGTTCCCTTAGATAAAGAATTTAGAAAATATACTGCATTTACCATACCTAGTCTAAACAATGAGACACCAGGGATTAGATATCAGTACAATGTGCTTCCACAGGGATGGAAAGGATCACCAGCAATATTTCAATGTAGCATGACAAAAATCTTAGAGCCTTTTAGAAAACAAAATCCAGACATAGTTATATATCAATACATGGATGATTTGTATGTAGGATCTGACTTAGAAATAGAGCAGCATAGAACAAAAATAGAGGAACTGAGACAACATCTGTTGAGGTGGGGATTTACCACACCAGACAAAAAACATCAGAAAGAGCCTCCATTCCTTTGGATGGGTTATGAACTCCATCCTGATAAATGGACAGTACAGCCTATAATGCTGCCAGAAAAAGACAGCTGGACTGTCAATGACATACAGAAGTTAGTAGGAAAATTAAATTGGGCAAGTCAGATTTATCCAGGGATTAAAGTAAAACAATTGTGT")

#sef = Bio::FastaFormat.new(">query\nCCTCAAATCACTCTTTGGCAGCGACCCCTCGTTGCAATAAAGATAGGGGGGCAGCTAAAGGAAGCTCTATTAGATACAGGAGCAGATGATACAGTATTAGAAGAAATGAATTTAACAGGGAAATGGAAACCAAAAATGATAGGGGGAATTGGAGGTTTTATCAAAGTGAAACAGTATGATCAGGTAGCTATAGAAATCTGTGGACATAAAGTTACAGGTACAGTATTAGTAGGACCCACACCTGTCAATATAATTGGAAGGAATCTGTTGACTCAGCTTGGCTGCACTTTAAATTTTCCCATTAGTCCTATTGAAACTGTACCAGTAAAATTAAAGCCAGGAATGGATGGCCCAAAAGTAAAACAATGGCCATTGACAGAAGAAAAAATAAAAGCATTAATAGAAATTTGCACAGAAATGGAAAAGGAAGGGAAAATTTCAAAAATTGGGCCTGAAAATCCATACAATACTCCAGTGTTTGCAATAAAGAAGAAAGACAGTACTAAATGGAGAAAATTAGTAGATTTCAGAGAACTTAATAAAAGGACTCAAGACTTCTGGGAAGTTCAATTAGGAATACCACATCCTGCAGGGTTAAAAAAGAAAAAATCAGTAACAGTACTGGATGTGGGTGATGCATATTTTTCAGTTCCCTTAGATAAAGAATTTAGAAAATATACTGCATTTACCATACCTAGTCTAAACAATGAGACACCAGGGATTAGATATCAGTACAATGTGCTTCCACAGGGATGGAAAGGATCACCAGCAATATTTCAATGTAGCATGACAAAAATCTTAGAGCCTTTTAGAAAACAAAATCCAGACATAGTTATATATCAATACATGGATGATTTGTATGTAGGATCTGACTTAGAAATAGAGCAGCATAGAACAAAAATAGAGGAACTGAGACAACATCTGTTGAGGTGGGGATTTACCACACCAGACAAAAAACATCAGAAAGAGCCTCCATTCCTTTGGATGGGTTATGAACTCCATCCTGATAAATGGACAGTACAGCCTATAATGCTGCCAGAAAAAGACAGCTGGACTGTCAATGACATACAGAAGTTAGTAGGAAAATTAAATTGGGCAAGTCAGATTTATCCAGGGATTAAAGTAAAACAATTGTGT")
query_string = ">query\n" << seq
sef = Bio::FastaFormat.new(query_string)

report = factory.query(sef)

highhit = Hash.new
highhif = Hash.new

report.each do |hit|
  if hit.bit_score > 0.8 * seq.length
    highhit[hit.target_id] = hit
  end
end

report = factorf.query(sef)
#puts factorf.output
#puts report.list
print "================\n"
#puts report.hits
report.each() do |hit|
  print "#{hit.query_id} : evalue #{hit.evalue}\t#{hit.target_id} at "
  p hit.lap_at
  if highhif.has_key?(hit.target_id)
    print "#{hit.target_id} has multiple hits.\n"
    if highhif[hit.target_id].overlap > hit.overlap
      highhif[hit.target_id] = hit
    end
  else
    highhif[hit.target_id] = hit
  end
end

print "================\n"
besthit = [ nil, 10000]
coordinates = [ 1, 10000 ]
highhit.each do |tg, hit|
  print "<BLAST> #{hit.target_id}: E=#{hit.evalue}, score=#{hit.bit_score}, Lap at #{hit.lap_at}\n"
#  print "\n"
#  print "Query:\n"
#  p hit.query_seq
#  print "\n"
#  p hit.midline
#  print "\n"
#  print "Target:\n"
#  p hit.target_seq
#  print "\n"
  lt = hit.target_len
  besthit = [ hit.target_id, lt ] if lt < besthit[1]
  coordinates = [hit.lap_at[2], hit.lap_at[3]] if hit.target_id == "Full"
end
besthif = Hash.new
print "--------------------------------------------------\n"
highhif.each do |tg, hit|
  if hit.evalue < 1e-100
    besthif[hit.target_id] = hit
  end
  print "<FASTA> #{hit.target_id}: E=#{hit.evalue}, score=#{hit.sw}, ID=#{hit.identity}, at #{hit.lap_at}\n"
  print "\n"
  print "Query:\n"
  p hit.query_seq
  print "\n"
  print "Target:\n"
  p hit.target_seq
  print "\n"
  lt = hit.target_len
#  besthit = [ hit.target_id, lt ] if lt < besthit[1]
  coordinates = [hit.lap_at[2], hit.lap_at[3]] if hit.target_id == "Full"
end

shortest = [nil, 10000]
besthif.each do |tg, hit|
  lt = hit.target_len
  shortest = [ tg, lt ] if lt < shortest[1]
  print "#{tg}\n"
end
print "Shortest hit = #{shortest[0]}\n"

hxbaligned = Bio::Sequence::NA.new(highhit[besthit[0]].target_seq)
inslist = hxbaligned.detectins
print "#{besthit[0]}: #{highhit[besthit[0]].target_start} - #{highhit[besthit[0]].target_end}: Inserts=#{inslist.to_s}\n"

#queryaligned = Bio::Sequence::NA.new(highhit[besthit[0]].query_seq)
queryaligned = Bio::Sequence::NA.new("ATGGCAGA--A-GTGAT---A")
correctedquery = queryaligned.correctins(1)
correctedquery.upcase!

insline = String.new 
inslist.each do |i|
  insline << i[0].to_s
  insline << "-"
  insline << i[1].to_s
  insline << ","
end
insline.chop!

print "Coordinates: #{coordinates.to_s}, Insertion: #{insline}\n"
print "Corrected query:\n#{correctedquery}\n"
