require 'bio'

f_str = <<END_OF_STRING
>sce:YBR160W|CDC28, SRM5|cyclin-dependent protein kinase catalytic subunit|[EC:2.7.1.-]|[SP:CC28_YEAST]
MSGELANYKRLEKVGEGTYGVVYKALDLRPGQGQRVVALKKIRLESEDEG
VPSTAIREISLLKELKDDNIVRLYDIVHSDAHKLYLVFEFLDLDLKRYME
GIPKDQPLGADIVKKFMMQLCKGIAYCHSHRILHRDLKPQNLLINKDGNL
KLGDFGLARAFGVPLRAYTHEIVTLWYRAPEVLLGGKQYSTGVDTWSIGC
IFAEMCNRKPIFSGDSEIDQIFKIFRVLGTPNEAIWPDIVYLPDFKPSFP
QWRRKDLSQVVPSLDPRGIDLLDKLLAYDPINRISARRAAIHPYFQES
>sce:YBR274W|CHK1|probable serine/threonine-protein kinase [EC:2.7.1.-] [SP:KB9S_YEAST]
MSLSQVSPLPHIKDVVLGDTVGQGAFACVKNAHLQMDPSIILAVKFIHVP
TCKKMGLSDKDITKEVVLQSKCSKHPNVLRLIDCNVSKEYMWIILEMADG
GDLFDKIEPDVGVDSDVAQFYFQQLVSAINYLHVECGVAHRDIKPENILL
DKNGNLKLADFGLASQFRRKDGTLRVSMDQRGSPPYMAPEVLYSEEGYYA
DRTDIWSIGILLFVLLTGQTPWELPSLENEDFVFFIENDGNLNWGPWSKI
EFTHLNLLRKILQPDPNKRVTLKALKLHPWVLRRASFSGDDGLCNDPELL
AKKLFSHLKVSLSNENYLKFTQDTNSNNRYISTQPIGNELAELEHDSMHF
QTVSNTQRAFTSYDSNTNYNSGTGMTQEAKWTQFISYDIAALQFHSDEND
CNELVKRHLQFNPNKLTKFYTLQPMDVLLPILEKALNLSQIRVKPDLFAN
FERLCELLGYDNVFPLIINIKTKSNGGYQLCGSISIIKIEEELKSVGFER
KTGDPLEWRRLFKKISTICRDIILIPN
END_OF_STRING

Bio::FlatFile.open('testseq.fas') do |ff|
ff.each do |f|

#f = Bio::FastaFormat.new(f_str)
puts f
puts "### FastaFormat"
puts "# entry"
puts f.entry
puts "# entry_id"
p f.entry_id
puts "# gi"
p f.gi
puts "# identifiers"
p f.identifiers
puts "# definition"
p f.definition
puts "# data"
p f.data
puts "# seq"
p f.seq
puts "# length"
p f.length
puts "# aaseq"
p f.aaseq
puts "# aaseq.composition"
p f.aaseq.composition
puts "# aalen"
p f.aalen
puts "# accessions"
p f.accessions
puts "# to_biosequence"
p f.to_biosequence
puts "# smartranslate?"
p Bio::Sequence::NA.method_defined?(:translate)
end
end
