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
      i = p + l
    end
    return inserts
  end

  def correctins(cs)
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
          when 0
            targetseq[staddr + 3] = targetseq[staddr + 1]
            targetseq[staddr + 1] = '-'
          when 1
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 1] = targetseq[staddr + 4]
            targetseq[staddr + 4] = '-'
          when 2
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 1] = '-'
          end
        elsif targetseq[edaddr + 3] == '-' && targetseq[edaddr + 4] == '-' && targetseq[edaddr + 5] != '-'
          joinflag = true
          case cop
          when 0
            targetseq[staddr + 3] = targetseq[staddr + 1]
            targetseq[staddr + 4] = targetseq[staddr + 2]
            targetseq[staddr + 1] = '-'
            targetseq[staddr + 2] = '-'
          when 1
            targetseq[staddr] = targetseq[staddr + 1]
            targetseq[staddr + 1] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          when 2
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
          when 0
            targetseq[staddr + 3] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          when 1
            targetseq[staddr + 3] = targetseq[staddr + 2]
            targetseq[staddr + 2] = targetseq[staddr - 1]
            targetseq[staddr - 1] = '-'
          when 2
            targetseq[staddr] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          end
        elsif targetseq[edaddr + 3] == '-' && targetseq[edaddr + 4] != '-'
          joinflag = true
          case cop
          when 0
            targetseq[staddr + 4] = targetseq[staddr + 3]
            targetseq[staddr + 3] = targetseq[staddr + 2]
            targetseq[staddr + 2] = '-'
          when 1
            targetseq[staddr] = targetseq[staddr + 2]
            targetseq[staddr + 1] = targetseq[staddr + 3]
            targetseq[staddr + 2] = '-'
            targetseq[staddr + 3] = '-'
          when 2
            targetseq[staddr] = targetseq[staddr + 2]
            targetseq[staddr + 4] = targetseq[staddr + 3]
            targetseq[staddr + 2] = '-'
            targetseq[staddr + 3] = '-'
          end
        end
      when 3
        case cop
        when 1
          targetseq[edaddr] = targetseq[staddr - 1]
          targetseq[staddr - 1] = '-'
        when 2
          targetseq[staddr] = targetseq[edaddr + 1]
          targetseq[edaddr + 1] = '-'
        else
          next
        end
      else
      end
    end
    return targetseq
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
