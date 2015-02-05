require 'rails_helper'

RSpec.describe "patients/index", :type => :view do
  before(:each) do
    assign(:patients, [
      Patient.create!(
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
      ),
      Patient.create!(
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
      )
    ])
  end

  it "renders a list of patients" do
    render
    assert_select "tr>td", :text => "Niid".to_s, :count => 2
    assert_select "tr>td", :text => "Lab".to_s, :count => 2
    assert_select "tr>td", :text => "Affiliation".to_s, :count => 2
    assert_select "tr>td", :text => "Hosp".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "Nationarity".to_s, :count => 2
    assert_select "tr>td", :text => "Edu Background".to_s, :count => 2
    assert_select "tr>td", :text => "Occupation".to_s, :count => 2
    assert_select "tr>td", :text => "Marital Status".to_s, :count => 2
    assert_select "tr>td", :text => "Risk".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
