require 'rails_helper'

RSpec.describe "patients/new", :type => :view do
  before(:each) do
    assign(:patient, Patient.new(
      :niid_id => "MyString",
      :lab_id => "MyString",
      :affiliation => "MyString",
      :hosp_id => "MyString",
      :gender => "MyString",
      :nationarity => "MyString",
      :edu_background => "MyString",
      :occupation => "MyString",
      :marital_status => "MyString",
      :risk => "MyString",
      :operator_id => 1
    ))
  end

  it "renders new patient form" do
    render

    assert_select "form[action=?][method=?]", patients_path, "post" do

      assert_select "input#patient_niid_id[name=?]", "patient[niid_id]"

      assert_select "input#patient_lab_id[name=?]", "patient[lab_id]"

      assert_select "input#patient_affiliation[name=?]", "patient[affiliation]"

      assert_select "input#patient_hosp_id[name=?]", "patient[hosp_id]"

      assert_select "input#patient_gender[name=?]", "patient[gender]"

      assert_select "input#patient_nationarity[name=?]", "patient[nationarity]"

      assert_select "input#patient_edu_background[name=?]", "patient[edu_background]"

      assert_select "input#patient_occupation[name=?]", "patient[occupation]"

      assert_select "input#patient_marital_status[name=?]", "patient[marital_status]"

      assert_select "input#patient_risk[name=?]", "patient[risk]"

      assert_select "input#patient_operator_id[name=?]", "patient[operator_id]"
    end
  end
end
