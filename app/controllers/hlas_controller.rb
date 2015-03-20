class HlasController < ApplicationController
  before_action :signed_in_user, only: [:index, :new, :newa, :newb, :newc, :edit, :edita, :editb, :editc, :update, :create, :destroy]
  before_action :set_patient, only: [:edita, :editb, :editc, :newa, :newb, :newc, :destroy]
  before_action :set_hlas, only: [:edita, :editb, :editc, :update]
  before_action :set_locus_as, only: [:edita]
  before_action :set_locus_bs, only: [:editb]
  before_action :set_locus_cs, only: [:editc]

  def new
    @hla1 = Hla.new
    @patient = Patient.find(params[:id])
  end

  def newa
    @hla1 = Hla.new(type: "LocusA")
    @hla2 = Hla.new(type: "LocusA")
#    @hla1.type = "LocusA"
#    @hla2.type = "LocusA"
#    @patient = Patient.find(params[:id])
    @serotypes = SerotypeMasterA.order(:priority, :name).pluck(:name)
    @alleles1 = %w( Not_ready. )
    @alleles2 = %w( Not_ready. )
  end

  def newb
    @hla1 = Hla.new(type: "LocusB")
    @hla2 = Hla.new(type: "LocusB")
#    @hla1.type = "LocusB"
#    @hla2.type = "LocusB"
#    @patient = Patient.find(params[:id])
    @serotypes = SerotypeMasterB.order(:priority, :name).pluck(:name)
    @alleles1 = %w( Not_ready. )
    @alleles2 = %w( Not_ready. )
  end

  def newc
    @hla1 = Hla.new(type: "LocusC")
    @hla2 = Hla.new(type: "LocusC")
#    @hla1.type = "LocusC"
#    @hla2.type = "LocusC"
#    @patient = Patient.find(params[:id])
    @serotypes = SerotypeMasterC.order(:priority, :name).pluck(:name)
    @alleles1 = %w( Not_ready. )
    @alleles2 = %w( Not_ready. )
  end

  def index
    @patients = Patient.order("niid_id")
    @locus_as = LocusA.all
    @locus_bs = LocusB.all
    @locus_cs = LocusC.all
  end

  def edit
  end

  def edita
    hla = Array.new
    @locus_as.each do |g|
      hla.push(g)
    end
    @hla1 = hla[0]
    @hla2 = hla[1]
    @hla1.dserotype = @hla2.serotype
    @hla1.dallele = @hla2.allele
    @serotypes = SerotypeMasterA.order(:priority, :name).pluck(:name)
    @master_id = SerotypeMasterA.where(name: @hla1.serotype).pluck(:id)
    @alleles1 = AlleleMasterA.where(serotype_master_a: @master_id).pluck(:name, :name)
    @master_id = SerotypeMasterA.where(name: @hla2.serotype).pluck(:id)
    @alleles2 = AlleleMasterA.where(serotype_master_a: @master_id).pluck(:name, :name)
  end

  def editb
    hla = Array.new
    @locus_bs.each do |g|
      hla.push(g)
    end
    @hla1 = hla[0]
    @hla2 = hla[1]
    @hla1.dserotype = @hla2.serotype
    @hla1.dallele = @hla2.allele
    @serotypes = SerotypeMasterB.order(:priority, :name).pluck(:name)
    @master_id = SerotypeMasterB.where(name: @hla1.serotype).pluck(:id)
    @alleles1 = AlleleMasterB.where(serotype_master_b: @master_id).pluck(:name, :name)
    @master_id = SerotypeMasterB.where(name: @hla2.serotype).pluck(:id)
    @alleles2 = AlleleMasterB.where(serotype_master_b: @master_id).pluck(:name, :name)
  end

  def editc
    hla = Array.new
    @locus_cs.each do |g|
      hla.push(g)
    end
    @hla1 = hla[0]
    @hla2 = hla[1]
    @hla1.dserotype = @hla2.serotype
    @hla1.dallele = @hla2.allele
    @serotypes = SerotypeMasterC.order(:priority, :name).pluck(:name)
    @master_id = SerotypeMasterC.where(name: @hla1.serotype).pluck(:id)
    @alleles1 = AlleleMasterC.where(serotype_master_c: @master_id).pluck(:name, :name)
    @master_id = SerotypeMasterC.where(name: @hla2.serotype).pluck(:id)
    @alleles2 = AlleleMasterC.where(serotype_master_c: @master_id).pluck(:name, :name)
  end

  def create
    if params.has_key?(:locus_a) then
      @hla1 = LocusA.new(locus_a_params)
      @hla2 = LocusA.new
      @hla2.patient_id = params[:locus_a][:patient_id]
      @hla2.date_exam = @hla1.date_exam
      if LocusA.exists?(:patient_id => @hla1.patient_id) then
      # Error routine
        respond_to do |format|
          format.html { render action: 'index' }
          format.json { render json: @hlas.errors, status: :unprocessable_entity }
        end
      end
      if params[:homozygote] == "Submit_as_Homozygote" then
        @hla2.serotype = @hla1.serotype
	@hla2.allele = @hla1.allele
      else
        @hla2.serotype = params[:locus_a][:dserotype]
        @hla2.allele = params[:locus_a][:dallele]
      end
    elsif params.has_key?(:locus_b) then
      @hla1 = LocusB.new(locus_b_params)
      @hla2 = LocusB.new
      @hla2.patient_id = params[:locus_b][:patient_id]
      @hla2.date_exam = @hla1.date_exam
      if LocusB.exists?(:patient_id => @hla1.patient_id) then
        respond_to do |format|
          format.html { render action: 'index' }
          format.json { render json: @hlas.errors, status: :unprocessable_entity }
        end
      end
      if params[:homozygote] == "Submit_as_Homozygote" then
        @hla2.serotype = @hla1.serotype
        @hla2.allele = @hla1.allele
      else
        @hla2.serotype = params[:locus_b][:dserotype]
        @hla2.allele = params[:locus_b][:dallele]
      end
    elsif params.has_key?(:locus_c) then
      @hla1 = LocusC.new(locus_c_params)
      @hla2 = LocusC.new
      @hla2.patient_id = params[:locus_c][:patient_id]
      @hla2.date_exam = @hla1.date_exam
      if LocusC.exists?(:patient_id => @hla1.patient_id) then
        respond_to do |format|
          format.html { render action: 'index' }
          format.json { render json: @hlas.errors, status: :unprocessable_entity }
        end
      end
      if params[:homozygote] == "Submit_as_Homozygote" then
        @hla2.serotype = @hla1.serotype
        @hla2.allele = @hla1.allele
      else
        @hla2.serotype = params[:locus_c][:dserotype]
        @hla2.allele = params[:locus_c][:dallele]
      end
    else
      # Error routine
      respond_to do |format|
	format.html { render action: 'index' }
        format.json { render json: @hlas.errors, status: :unprocessable_entity }
      end
    end

    @hla1.operator_id = current_user.id
    @hla2.operator_id = current_user.id

    if @hla1.serotype == @hla2.serotype && @hla1.allele == @hla2.allele then
      @hla1.homo = true
      @hla2.homo = true
    else
      @hla1.homo = false
      @hla2.homo = false
    end
    if /\d\d/ !~ @hla1.allele then
      @hla1.allele = ''
    elsif /\d\d/ !~ @hla2.allele then
      @hla2.allele = ''
    end

    respond_to do |format|
      if @hla1.save && @hla2.save
        format.html { redirect_to '/hlas', notice: 'HLA genotype was successfully created.' }
#        format.json { render action: 'show', status: :created, location: @hla1 }
      else
        format.html { redirect_to '/hlas', notice: @hla1.errors.full_messages }
#        format.json { render json: @hla1.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params.has_key?(:locus_a) then
      @locus_as = LocusA.where(patient_id: params[:locus_a][:patient_id])
      hla = Array.new
      @locus_as.each do |g|
        hla.push(g)
      end
      @hla1 = hla[0]
      @hla2 = hla[1]
      @hla1.update(locus_a_params)
      @hla2.patient_id = params[:locus_a][:patient_id]
      @hla2.date_exam = @hla1.date_exam
      if params[:homozygote] == "Submit_as_Homozygote" then
        @hla2.serotype = @hla1.serotype
        @hla2.allele = @hla1.allele
      else
        @hla2.serotype = params[:locus_a][:dserotype]
        @hla2.allele = params[:locus_a][:dallele]
      end
    elsif params.has_key?(:locus_b) then
      @locus_bs = LocusB.where(patient_id: params[:locus_b][:patient_id])
      hla = Array.new
      @locus_bs.each do |g|
        hla.push(g)
      end
      @hla1 = hla[0]
      @hla2 = hla[1]
      @hla1.update(locus_b_params)
      @hla2.patient_id = params[:locus_b][:patient_id]
      @hla2.date_exam = @hla1.date_exam
      if params[:homozygote] == "Submit_as_Homozygote" then
        @hla2.serotype = @hla1.serotype
        @hla2.allele = @hla1.allele
      else
        @hla2.serotype = params[:locus_b][:dserotype]
        @hla2.allele = params[:locus_b][:dallele]
      end
    elsif params.has_key?(:locus_c) then
      @locus_cs = LocusC.where(patient_id: params[:locus_c][:patient_id])
      hla = Array.new
      @locus_cs.each do |g|
        hla.push(g)
      end
      @hla1 = hla[0]
      @hla2 = hla[1]
      @hla1.update(locus_c_params)
      @hla2.patient_id = params[:locus_c][:patient_id]
      @hla2.date_exam = @hla1.date_exam
      if params[:homozygote] == "Submit_as_Homozygote" then
        @hla2.serotype = @hla1.serotype
        @hla2.allele = @hla1.allele
      else
        @hla2.serotype = params[:locus_c][:dserotype]
        @hla2.allele = params[:locus_c][:dallele]
      end
    else
      # Error routine
      respond_to do |format|
        format.html { render action: 'index' }
        format.json { render json: @hlas.errors, status: :unprocessable_entity }
      end
    end
    @hla1.operator_id = current_user.id
    @hla2.operator_id = current_user.id
    if @hla1.serotype == @hla2.serotype && @hla1.allele == @hla2.allele then
      @hla1.homo = true
      @hla2.homo = true
    else
      @hla1.homo = false
      @hla2.homo = false
    end
    if /\d\d/ !~ @hla1.allele then
      @hla1.allele = ''
    elsif /\d\d/ !~ @hla2.allele then
      @hla2.allele = ''
    end

    respond_to do |format|
      if @hla1.save && @hla2.save
        format.html { redirect_to '/hlas', notice: 'HLA genotype was successfully updated.' }
      else
        format.html { redirect_to '/hlas', notice: @hla1.errors.full_messages }
      end
    end
  end

  def destroy
    case params[:locus]
    when 'A' then
      hla_id = @patient.locus_as.pluck(:id)
      hla_id.each{|i|
        LocusA.find(i).destroy
      }
    when 'B' then
      hla_id = @patient.locus_bs.pluck(:id)
      hla_id.each{|i|
        LocusB.find(i).destroy
      }
    when 'C' then
      hla_id = @patient.locus_cs.pluck(:id)
      hla_id.each{|i|
        LocusC.find(i).destroy
      }
    else

    end

    respond_to do |format|
      format.html { redirect_to '/hlas' }
      format.json { head :no_content }
    end
  end

  def serotype_select1
    @seroname = params[:serotype_name].slice!(0, 2)
    @locus = params[:locus]
    if @locus == 'LocusA' then
      @master_id = SerotypeMasterA.where(name: @seroname).pluck(:id)
      @alleles1 = AlleleMasterA.where(serotype_master_a: @master_id).pluck(:name, :name)
      @alleles1.unshift(["Ready!!", ""])
      render 'serotype_selecta1'
    elsif @locus == 'LocusB' then
      @master_id = SerotypeMasterB.where(name: @seroname).pluck(:id)
      @alleles1 = AlleleMasterB.where(serotype_master_b: @master_id).pluck(:name, :name)
      @alleles1.unshift(["Ready!!", ""])
      render 'serotype_selectb1'
    elsif @locus == 'LocusC' then
      @master_id = SerotypeMasterC.where(name: @seroname).pluck(:id)
      @alleles1 = AlleleMasterC.where(serotype_master_c: @master_id).pluck(:name, :name)
      @alleles1.unshift(["Ready!!", ""])
      render 'serotype_selectc1'
    else
      @alleles1.unshift(["Error!!", ""])
    end
  end

  def serotype_select2
    @seroname2 = params[:serotype_name2].slice!(0, 2)
    @locus = params[:locus]
    if @locus == 'LocusA' then
      @master_id = SerotypeMasterA.where(name: @seroname2).pluck(:id)
      @alleles2 = AlleleMasterA.where(serotype_master_a: @master_id).pluck(:name, :name)
      @alleles2.unshift(["Ready!", ""])
      render 'serotype_selecta2'
    elsif @locus == 'LocusB' then
      @master_id = SerotypeMasterB.where(name: @seroname2).pluck(:id)
      @alleles2 = AlleleMasterB.where(serotype_master_b: @master_id).pluck(:name, :name)
      @alleles2.unshift(["Ready!", ""])
      render 'serotype_selectb2'
    elsif @locus == 'LocusC' then
      @master_id = SerotypeMasterC.where(name: @seroname2).pluck(:id)
      @alleles2 = AlleleMasterC.where(serotype_master_c: @master_id).pluck(:name, :name)
      @alleles2.unshift(["Ready!", ""])
      render 'serotype_selectc2'
    else
      @alleles1.unshift(["Error!!", ""])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    def set_hlas
      @hlas = Hla.where(patient_id: params[:id])
    end

    def set_locus_as
      @locus_as = LocusA.where(patient_id: params[:id])
    end

    def set_locus_bs
      @locus_bs = LocusB.where(patient_id: params[:id])
    end

    def set_locus_cs
      @locus_cs = LocusC.where(patient_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:niid_id, :lab_id, :affiliation, :hosp_id, :gender, :nationarity, :date_of_birth, :date_diagnosed, :edu_background, :occupation, :marital_status, :risk, :operator_id)
    end

    def hla_params
      params.require(:hla).permit(:type, :patient_id, :date_exam, :serotype, :allele, :homo, :operator_id, :dserotype, :dallele)
    end

    def locus_a_params
      params.require(:locus_a).permit(:type, :patient_id, :date_exam, :serotype, :allele, :homo, :operator_id, :dserotype, :dallele)
    end

    def locus_b_params
      params.require(:locus_b).permit(:type, :patient_id, :date_exam, :serotype, :allele, :homo, :operator_id, :dserotype, :dallele)
    end

    def locus_c_params
      params.require(:locus_c).permit(:type, :patient_id, :date_exam, :serotype, :allele, :homo, :operator_id, :dserotype, :dallele)
    end

end
