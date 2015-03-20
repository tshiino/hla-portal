require 'rails_helper'

RSpec.describe "samples/show", :type => :view do
  before(:each) do
    @sample = assign(:sample, Sample.create!(
      :patient => nil,
      :art_status => false,
      :art_formula => "Art Formula",
      :cd4_count => 1.5,
      :viral_load => 1.5,
      :condition => "Condition",
      :remarks => "Remarks",
      :operator_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Art Formula/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Condition/)
    expect(rendered).to match(/Remarks/)
    expect(rendered).to match(/1/)
  end
end
