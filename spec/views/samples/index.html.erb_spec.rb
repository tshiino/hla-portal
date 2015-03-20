require 'rails_helper'

RSpec.describe "samples/index", :type => :view do
  before(:each) do
    assign(:samples, [
      Sample.create!(
        :patient => nil,
        :art_status => false,
        :art_formula => "Art Formula",
        :cd4_count => 1.5,
        :viral_load => 1.5,
        :condition => "Condition",
        :remarks => "Remarks",
        :operator_id => 1
      ),
      Sample.create!(
        :patient => nil,
        :art_status => false,
        :art_formula => "Art Formula",
        :cd4_count => 1.5,
        :viral_load => 1.5,
        :condition => "Condition",
        :remarks => "Remarks",
        :operator_id => 1
      )
    ])
  end

  it "renders a list of samples" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Art Formula".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Condition".to_s, :count => 2
    assert_select "tr>td", :text => "Remarks".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
