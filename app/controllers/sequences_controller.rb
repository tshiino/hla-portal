class SequencesController < ApplicationController
  require 'bioshead'
  class Bio::Sequence::NA
    include Sheadna
  end
  class Bio::Sequence::AA
    include Sheadaa
  end
  before_action :signed_in_user, only:[:index, :show, :new, :edit, :update, :create, :destroy, :upload, :import]
  before_action :set_sequence, only: [:show, :edit, :update, :destroy]
  before_action :set_sample, only: [:show]
  before_action :set_patient, only: [:show]

  def new
  end

  def index
    @sequences = Sequence.all
    @samples = Sample.all
    @patients = Patient.order("niid_id")
  end

  def edit
  end

  def update
  end

  def create
    respond_to do |format|
      if @sequence.save
        format.html { redirect_to @sequence, notice: 'Sequence was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sequence }
      else
        format.html { render action: 'new' }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @sequence.destroy
    respond_to do |format|
      format.html { redirect_to sequences_url }
      format.json { head :no_content }
    end
  end

  def show
    @naseq = Bio::Sequence::NA.new(@sequence.sequence)
    @aaseq = String.new(@sequence.translation)
    @seqcompo = @naseq.composition
    @mutations = Mutation.where(sequence_id: @sequence.id)
    @insrange = Array.new
    @inslines = Array.new
    inslist = @sequence.insertion.split(",")
    inslist.each do |il|
      if /(\d+)-(\d+)/ =~ il then
        @insrange << Range.new($1.to_i, $2.to_i)
      end
    end
    len = @naseq.length
    spaces = " " * len   # 'len - spaces + 1' = current site position.
    while spaces.size > 0 do
      ln = ""
      60.times do
        break if spaces.size == 0
        nohxb = false
        mutaa = " "
        @insrange.each do |ir|
          nohxb = true if ir.include?(len - spaces.size + 1)
        end
        aap = (len - spaces.size + 3).divmod(3)
        if @mutations.exists?(:locus => aap[0]) then
          if @mutations.find_by(:locus => aap[0]).wildtype != 'In' then
            case aap[1]
            when 0 then
              mutaa = '['
            when 1 then
              mutaa = @mutations.find_by(:locus => aap[0]).wildtype
            when 2 then
              mutaa = ']'
            end
          end
        end
        if nohxb then
          ln << "^"
          spaces.slice!(0)
        elsif mutaa != ' '
          ln << mutaa
          spaces.slice!(0)
        else
          ln << spaces.slice!(0)
        end
      end
      @inslines.push(ln)
    end
    @figure = Array.new{ Array.new(3) }
    #@figure << [0, @sequence.translation, 60]
    @figure.concat( @naseq.to_fig(@aaseq) )
  end

  def upload
    @sequence = Sequence.new
  end

  def import
    @seqorg = Hash.new
    options = Hash.new
    par = Array.new
    comments = Array.new
    aa = String.new
    if params[:fasta_file].blank?
      redirect_to(sequences_path, alert: 'Select FASTA file to upload')
    else
      Bio::FlatFile.open(params[:fasta_file].path) do |ff|
        ff.each do |f|
          @sequence = Sequence.new(sequence_params)
          if /(^.+?)[\W_]*(gag|pol|env|nef|PRRT|IN)$/i =~ f.entry_id then
            patid = $1
            geneatf = $2
          else
            patid = f.entry_id
          end
          if @patient = Patient.find_by(niid_id: patid) then
            next unless @patient.samples.present?
            @sequence.sample_id = @patient.samples.order(:date_sample_taken).first.id
            @sequence.read = Sequence.where(sample_id: @sequence.sample_id).count + 1
            cs = @sequence.codon_start
            comments = f.definition.sub(/#{f.entry_id}/, '').split("|")
            comments.each do |c|
              case c
              when /^sn=(\d+)/i then
                @sequence.sample_id = $1 if Sample.exist?(id: $1)
              when  /^i\w*=([\d\-\,]+)/i then
                @sequence.insertion = $1
              when /^su\w*=(\w{1,2})/i then
                @sequence.subtype_code = $1
              when /^co\w*=([1-3])/i then
                options[:codon_start] = $1
                cs = $1
              when /^g\w*=(\w+)/i then
                options[:gene] = $1
                @sequence.gene, options[:gene] = options[:gene], @sequence.gene
              when /^d\w*=(\d\d\d\d-\d\d-\d\d)/i then
                options[:date_seq] = $1
                @sequence.date_seq, options[:date_seq] = options[:date_seq], @sequence.date_seq
              when /^cl\w*$/i then
                options[:clonal] = true
                @sequence.clonal, options[:clonal] = options[:clonal], @sequence.clonal
              when /^p\w*$/i then
                options[:provirus] = true
                @sequence.provirus, options[:provirus] = options[:provirus], @sequence.provirus
              when /^r\w*=(\d+)-(\d+)/i then
                options[:start] = $1
                options[:end] = $2
                 @sequence.start, options[:start] = options[:start], @sequence.start
                 @sequence.end, options[:end] = options[:end], @sequence.end
              when /^ac\w*=(\w+)/i then
                 @sequence.accession = $1
              end
            end
            naseq = Bio::Sequence::NA.new(f.seq)
            aa = naseq.exactranslate(cs)
            aaseq = Bio::Sequence::AA.new(aa)
            @sequence.length = f.length
            @sequence.sequence = naseq.to_s
            @sequence.subtype_code = options[:subtype_code]
            @sequence.translation = aa
            @sequence.operator_id = current_user.id
            ent = patid + "(" + f.length.to_s + "bp, S/N:" + @sequence.sample_id.to_s
            par.push(ent)

            unless @sequence.save
              redirect_to(sequences_path, notice: 'Error: Sequence cannot be created due to insufficient data format or lacking in mentions of the required field!!') and return
            end

            hxb = ProteinRef.where("name = ? and gene = ?", 'HXB2-LAI-IIIB-BRU', @sequence.gene ).first
            dif = ((@sequence.start + @sequence.codon_start - 1) - hxb.start ) / 3
            if dif > 0  # Add '-' to aaseq.
              aaseq.insert(0, "-" * dif)
            elsif dif < 0  # Truncate -dif residues from aaseq.
              aaseq.slice!(0, dif * -1)
            end
            aainsrange = Array.new
            inslist = @sequence.insertion.split(",")
            inslist.each do |il|
              if /(\d+)-(\d+)/ =~ il then
                  aainsrange << Range.new(($1.to_i + 2)/3 -1 + dif, ($2.to_i + 2)/3 -1 + dif)
              end
            end
            aa = String.new(aaseq.to_s)
            @muts = aaseq.substitutions(hxb.sequence, aainsrange)
            aainsrange.each do |air|
              @muts << "+#{air.first}#{aa[air]}"
            end
            @muts.each do |m|
              @mutation = Mutation.new
              @mutation.sequence_id = Sequence.last.id
              @mutation.gene = @sequence.gene
              if /^([A-Z]+)(\d+)(\D)/ =~ m then
                @mutation.wildtype = $1
                @mutation.locus = $2
                @mutation.mutated = $3
              elsif /^\+(\d+)(\D+),?$/ =~ m then
                @mutation.wildtype = 'In'
                @mutation.locus = $1
                @mutation.mutated = $2
              else
                next
              end
              @mutation.save
            end
            @aatran = aaseq.to_s
          end
          options.clear
        end
      end
    end
    redirect_to(sequences_path, notice: "Sequences (#{par.join(',')}), which code #{@sequence.gene} gene and range from #{@sequence.start} to #{@sequence.end}, were added to database.\n")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sequence
      @sequence = Sequence.find(params[:id])
    end
    def set_sample
      @sample = Sequence.find(params[:id]).sample
    end
    def set_patient
      @patient = Sequence.find(params[:id]).sample.patient
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sequence_params
      params.require(:sequence).permit(:sample_id, :date_seq, :gene, :start, :end, :length, :sequence, :insertion, :subtype_code, :codon_start, :translation, :clonal, :provirus, :notes, :operator_id)
    end
end
