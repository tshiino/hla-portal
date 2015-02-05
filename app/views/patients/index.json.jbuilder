json.array!(@patients) do |patient|
  json.extract! patient, :id, :niid_id, :lab_id, :affiliation, :hosp_id, :gender, :nationarity, :date_of_birth, :date_diagnosed, :edu_background, :occupation, :marital_status, :risk, :operator_id
  json.url patient_url(patient, format: :json)
end
