class PatientsController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
#    @patients = Patient.all
    @patients = Patient.order("niid_id")
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
