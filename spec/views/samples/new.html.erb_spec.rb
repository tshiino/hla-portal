require 'rails_helper'

RSpec.describe "samples/new", :type => :view do
  before(:each) do
    assign(:sample, Sample.new(
      :patient => nil,
      :art_status => false,
      :art_formula => "MyString",
      :cd4_count => 1.5,
      :viral_load => 1.5,
      :condition => "MyString",
      :remarks => "MyString",
      :operator_id => 1
    ))
  end

  it "renders new sample form" do
    render

    assert_select "form[action=?][method=?]", samples_path, "post" do

      assert_select "input#sample_patient_id[name=?]", "sample[patient_id]"

      assert_select "input#sample_art_status[name=?]", "sample[art_status]"

      assert_select "input#sample_art_formula[name=?]", "sample[art_formula]"

      assert_select "input#sample_cd4_count[name=?]", "sample[cd4_count]"

      assert_select "input#sample_viral_load[name=?]", "sample[viral_load]"

      assert_select "input#sample_condition[name=?]", "sample[condition]"

      assert_select "input#sample_remarks[name=?]", "sample[remarks]"

      assert_select "input#sample_operator_id[name=?]", "sample[operator_id]"
    end
  end
end
