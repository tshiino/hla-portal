class PatientsController < ApplicationController

  before_action :signed_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
#    @patients = Patient.all
    @patients = Patient.order("niid_id").paginate(page: params[:page])
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    @nationarity_name = @patient.country_code.country
    @operator_name = @patient.user.name
    if @patient.locus_as.exists? then
      @locus_as = @patient.locus_as.pluck(:serotype, :allele, :date_exam)
    else
      @locus_as = Array.new(2).map{Array.new(3)}
    end
    if @patient.locus_bs.exists? then
      @locus_bs = @patient.locus_bs.pluck(:serotype, :allele, :date_exam)
    else
      @locus_bs = Array.new(2).map{Array.new(3)}
    end
    if @patient.locus_cs.exists? then
      @locus_cs = @patient.locus_cs.pluck(:serotype, :allele, :date_exam)
    else
      @locus_cs = Array.new(2).map{Array.new(3)}
    end
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
    @nationarity_name = @patient.country_code.country
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)
    @patient.operator_id = current_user.id

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render action: 'show', status: :created, location: @patient }
      else
        format.html { render action: 'new' }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end

  def seeding
  end

  def gettemplate
    file_name="seeding_template.xlsx"
    filepath = Rails.root.join('public',file_name)
    stat = File::stat(filepath)
    send_file(filepath, :filename => file_name, :length => stat.size)
  end

  def import
    if params[:csv_file].blank?
      redirect_to(patients_path, alert: 'Select CSV file to seed')
    else
      test = Hash.new
      nums, invs, exts = 0, 0, 0
      numh, invh, exth = 0, 0, 0
      opid = current_user.id
      nump, invp, extp = Patient.import(params[:csv_file], opid)
      open(params[:csv_file].path, mode = "r", perm = 0666) do |f|
        seeds = CSV.new(f, :headers => :first_row)
        seeds.each do |r|
          next if r.header_row?
          record = Hash[[r.headers, r.fields].transpose]
          pid = Patient.find_by(:niid_id => record["niid_id"]).id
          sample_table = record.slice("date_sample_taken", "art_status", "art_formula", "cd4_count", "date_cd4_exam", "viral_load", "condition", "remarks", "serostatus")
          sample_table.store("patient_id", pid)
          sample_table.store("operator_id", current_user.id)
          ns, is, es = Sample.import(sample_table)
          nums += ns
          invs += is
          exts += es
          hla_table = record.slice("date_exam", "HLA_A1", "HLA_A2", "HLA_B1", "HLA_B2", "HLA_C1", "HLA_C2")
          atimes, btimes, ctimes = 0, 0, 0
          hla_table.each do |k, g|
            next if k == "data_exam"
            if /^HLA_A[12]/ =~ k
              atimes += 1
              if /^(?:A\*)?(\d\d)/ =~ g
                serotype = $1
                homo = false
                if atimes == 1 then
                  tally = serotype
                else
                  homo = true if tally == serotype
                end
                /\*\d\d:*(\d\d(?:\/\d\d)*)$/ =~ g
                allele = $1
                locus_table = { "date_exam" => hla_table["date_exam"], "patient_id" => pid, "serotype" => serotype, "allele" => allele, "homo" => homo, "operator_id" => current_user.id }
                nh, ih, eh = LocusA.import(locus_table)
                numh += nh
                invh += ih
                exth += eh
              else
                locus_table = { "date_exam" => hla_table["date_exam"], "patient_id" => pid, "serotype" => "00", "allele" => "00", "homo" => false, "operator_id" => current_user.id }
                nh, ih, eh = LocusA.import(locus_table)
                next
              end
            elsif /^HLA_B[12]/ =~ k
              btimes += 1
              if /^(?:B\*)?(\d\d)/ =~ g
                serotype = $1
                homo = false
                if atimes == 1 then
                  tally = serotype
                else
                  homo = true if tally == serotype
                end
                /\*\d\d:*(\d\d(?:\/\d\d)*)$/ =~ g
                allele = $1
                locus_table = { "date_exam" => hla_table["date_exam"], "patient_id" => pid, "serotype" => serotype, "allele" => allele, "homo" => homo, "operator_id" => current_user.id }
                nh, ih, eh = LocusB.import(locus_table)
                numh += nh
                invh += ih
                exth += eh
              else
                locus_table = { "date_exam" => hla_table["date_exam"], "patient_id" => pid, "serotype" => "00", "allele" => "00", "homo" => false, "operator_id" => current_user.id }
                nh, ih, eh = LocusB.import(locus_table)
                next
              end
            elsif /^HLA_C[12]/ =~ k
              ctimes += 1
              if /^(?:C\*)?(\d\d)/ =~ g
                serotype = $1
                homo = false
                if atimes == 1 then
                  tally = serotype
                else
                  homo = true if tally == serotype
                end
                /\*\d\d:*(\d\d(?:\/\d\d)*)$/ =~ g
                allele = $1
                locus_table = { "date_exam" => hla_table["date_exam"], "patient_id" => pid, "serotype" => serotype, "allele" => allele, "homo" => homo, "operator_id" => current_user.id }
                nh, ih, eh = LocusC.import(locus_table)
                numh += nh
                invh += ih
                exth += eh
              else
                locus_table = { "date_exam" => hla_table["date_exam"], "patient_id" => pid, "serotype" => "00", "allele" => "00", "homo" => false, "operator_id" => current_user.id }
                nh, ih, eh = LocusC.import(locus_table)
                next
              end
            else
              next
            end
            test = locus_table
          end
        end 
      end
      num = [nump, nums, numh]
      redirect_to(patients_path, notice: "Add #{num.max.to_s} records except #{invp.to_s} invalid and #{extp.to_s} existent patients, #{invs.to_s} invalid and #{exts.to_s} existent samples, and #{invh.to_s} invalid and #{exth.to_s} existent HLA alleles. #{test}")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:niid_id, :lab_id, :affiliation, :hosp_id, :gender, :nationarity, :date_of_birth, :date_diagnosed, :edu_background, :occupation, :marital_status, :risk, :date_of_art_init, :operator_id)
    end
end
