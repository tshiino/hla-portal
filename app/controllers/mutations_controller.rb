class MutationsController < ApplicationController
  before_action :signed_in_user, only:[:index, :edit, :show, :destroy]
  before_action :set_mutations, only: [:show, :edit, :destroy]
  before_action :set_sequence, only: [:show, :edit, :destroy]
  before_action :set_sample, only: [:show]
  before_action :set_patient, only: [:show]

  def show
    @muts = Array.new
    @mutations.each do |m|
      @muts << "#{m.wildtype}#{m.locus}#{m.mutated}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mutations
      @mutations = Mutation.where(sequence_id: params[:id])
    end
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
    def mutation_params
      params.require(:mutation).permit(:sequence_id, :gene, :wildtype, :locus, :mutated)
    end
end
