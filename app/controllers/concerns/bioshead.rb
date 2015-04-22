module Sheadna
  Version = '0.92'
  def exgencode
    am = String.new("X")
    case self.to_s
      when /[ut][ut][utcy]/i
        am = "F"
      when /[ut][ut][agr]/i
        am = "L"
      when /c[ut]\w/i
        am = "L"
      when /a[ut][acuth]/i
        am = "I"
      when /a[ut]g/i
        am = "M"
      when /g[ut]\w/i
        am = "V"
      when /[ut]c\w/i
        am = "S"
      when /cc\w/i
        am = "P"
      when /ac\w/i
        am = "T"
      when /gc\w/i
        am = "A"
      when /[ut]a[utcy]/i
        am = "Y"
      when /[ut]a[agr]/i
        am = "*"
      when /ca[utcy]/i
        am = "H"
      when /ca[agr]/i
        am = "Q"
      when /aa[utcy]/i
        am = "N"
      when /aa[agr]/i
        am = "K"
      when /ga[utcy]/i
        am = "D"
      when /ga[agr]/i
        am = "E"
      when /[ut]g[utcy]/i
        am = "C"
      when /[ut]ga/i
        am = "*"
      when /[ut]gg/i
        am = "W"
      when /cg\w/i
        am = "R"
      when /ag[utcy]/i
        am = "S"
      when /ag[agr]/i
        am = "R"
      when /gg\w/i
        am = "G"
      when /[agr]a[utcy]/i
        am = "B"
      when /[cgs]a[agr]/i
        am = "Z"
      when /-/
        am = "-"
      else
        am = "X"
    end
    return am
  end

  def exactranslate(codon_start = 1)
    length = self.length.divmod(3)
    aas = String.new
    for i in 1..length[0] do
      codon = self.slice(i * 3 + codon_start - 4, 3)
      aas << codon.exgencode
    end
    return aas
  end

  def to_fig(aaseq)
    i = 1
    figlines = Array.new{ Array.new(3) }
    naseqstr = String.new(self.to_s)
    self.window_search(60, 60) do |subseq|
      subaa = String.new
      figlines.push([i, subseq, i + 59])
      20.times {
        subaa << ' '
        subaa << aaseq.slice!(0)
        subaa << ' '
      }
      figlines.push([(i + 2)/3, subaa, 19 + (i + 2)/3])
      naseqstr.slice!(0, 60)
      i += 60
    end
    subaa = " "
    subaa << aaseq.split(//).join("  ")
    subaa << "  X" if naseqstr % 3 != 0
    figlines.push([i, naseqstr, i + naseqstr.size - 1 ], [(i + 2)/3, subaa, 19 + (i + 2)/3])
    return figlines
  end
end

module Sheadaa
  Version = '0.90'

  def substitutions(refseq, insertions)
    query = String(self.to_s)
    substitutes = Array.new
    insertions.each do |ir|  # Delete each insertion from query sequence.
      query[ir] = '+' * ir.size
    end
    query.delete!("+")
    1.upto(query.size) do |p|
      q = p - 1
      if query[q] != refseq[q] then
        substitutes << "#{refseq[q]}#{p}#{query[q]},"
      end
    end
    return substitutes
  end
end
