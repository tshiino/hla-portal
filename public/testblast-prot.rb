#!/usr/bin/env ruby

require 'bio'

factory = Bio::Blast.local('blastp', 'HXB2ProtDB')

seq = Bio::Sequence::AA.new("MGARASILSGGRLDAWEKIRLRPGGKKQYRLKHLVWASRELERFALNPGLLETAEGCQQLLEQLQSTLKTGSEELQSLFNTIATLWCVHQRIEIKDTKEALDKIXEVQNKSKKKAQQGPGSSSQVSQNYPIVQNAQGQMVHQPVSPRTLNAWVKVVEEKGFNPEVIPMFSALSEGATPQDLNMMLNIVGGHQGAMQMLKETINEEAAEWDRVHPVHAGPIPPGQMREPRGSDIAGTTSTLQEQIGWMTSNPPIPVGDIYKRWIILGLNKIVRMYSPVSILDIRQGPKEPFRDYVDRFYKTLRAEQATQEVKNWMTETLLVQNANPDCKSILKALGTGATLEEMMTACQGVGGPSHKARVLAEAMSHVQQ-ANVMMQRGNFKGQKR-IKCFNCGKEGHLARNCRAPRKKGCWKCGKEGHQMKDCTSERQANFLGKIWPSNKGRPGNFPQSRTEPTAPPAEDWGMGEGX--PS-----SRNRKTRN-IL--QFPSNHSLATTPCHN")

report = factory.query(seq)
report.each do |hit|
    if hit.evalue < 0.0001
      print "#{hit.query_id} : evalue #{hit.evalue}\t#{hit.target_id} at "
      p hit.lap_at
      print "\n"
      p hit.query_seq
      print "\n"
      p hit.midline
      print "\n"
      p hit.target_seq
      print "\n"
    end
end
