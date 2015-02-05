require 'rails_helper'

RSpec.describe "patients/show", :type => :view do
  before(:each) do
    @patient = assign(:patient, Patient.create!(
      :niid_id => "Niid",
      :lab_id => "Lab",
      :affiliation => "Affiliation",
      :hosp_id => "Hosp",
      :gender => "Gender",
      :nationarity => "Nationarity",
      :edu_background => "Edu Background",
      :occupation => "Occupation",
      :marital_status => "Marital Status",
      :risk => "Risk",
      :operator_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Niid/)
    expect(rendered).to match(/Lab/)
    expect(rendered).to match(/Affiliation/)
    expect(rendered).to match(/Hosp/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/Nationarity/)
    expect(rendered).to match(/Edu Background/)
    expect(rendered).to match(/Occupation/)
    expect(rendered).to match(/Marital Status/)
    expect(rendered).to match(/Risk/)
    expect(rendered).to match(/1/)
  end
end
