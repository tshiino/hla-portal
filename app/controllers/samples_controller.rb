class SamplesController < ApplicationController
  before_action :signed_in_user, only:[:index, :show, :new, :edit, :update, :create, :destroy]
  before_action :set_sample, only: [:show, :edit, :update, :destroy]
  before_action :set_patient, only: [:new]

  # GET /samples
  # GET /samples.json
  def index
#    @samples = Sample.all
    @samples = Sample.paginate(page: params[:page])
#    @patients = Patient.order("niid_id")
    @patients = Patient.order("niid_id").paginate(page: params[:page])
  end

  # GET /samples/1
  # GET /samples/1.json
  def show
  end

  # GET /samples/new
  def new
    @sample = Sample.new
  end

  # GET /samples/1/edit
  def edit
    @patient = Patient.find(@sample.patient_id)
  end

  # POST /samples
  # POST /samples.json
  def create
    @sample = Sample.new(sample_params)
    @sample.operator_id = current_user.id
    @patient = Patient.find(@sample.patient_id)

    respond_to do |format|
      if @sample.save
        format.html { redirect_to @sample, notice: 'Sample was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sample }
      else
        format.html { render action: 'new' }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /samples/1
  # PATCH/PUT /samples/1.json
  def update
    pat_id = @sample.patient_id
    respond_to do |format|
      if @sample.update(sample_params)
        @sample.patient_id = pat_id
        @sample.operator_id = current_user.id
        @sample.save
        format.html { redirect_to @sample, notice: 'Sample was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /samples/1
  # DELETE /samples/1.json
  def destroy
    @sample.destroy
    respond_to do |format|
      format.html { redirect_to samples_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sample_params
      params.require(:sample).permit(:patient_id, :date_sample_taken, :art_status, :art_formula, :cd4_count, :date_cd4_exam, :viral_load, :condition, :remarks, :operator_id, :serostatus)
    end
end
