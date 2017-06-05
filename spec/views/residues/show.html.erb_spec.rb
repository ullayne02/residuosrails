require 'rails_helper'

RSpec.describe "residues/show", type: :view do
  before(:each) do
    @residue = assign(:residue, Residue.create!(
      :name => "Name",
      :kind => "Kind",
      :blend => "Blend",
      :onu => "Onu",
      :code => "Code",
      :laboratory => nil,
      :collection => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Kind/)
    expect(rendered).to match(/Blend/)
    expect(rendered).to match(/Onu/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
