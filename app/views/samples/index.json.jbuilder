json.array!(@samples) do |sample|
  json.extract! sample, :id, :patient_id, :date_sample_taken, :art_status, :art_formula, :cd4_count, :date_cd4_exam, :viral_load, :condition, :remarks, :operator_id
  json.url sample_url(sample, format: :json)
end
