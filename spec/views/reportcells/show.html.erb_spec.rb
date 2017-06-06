require 'rails_helper'

RSpec.describe "reportcells/show", type: :view do
  before(:each) do
    @reportcell = assign(:reportcell, Reportcell.create!(
      :dep_name => "Dep Name",
      :lab_name => "Lab Name",
      :res_name => "Res Name",
      :kind => "Kind",
      :total => 2.5,
      :onu => "Onu",
      :state => "State",
      :blend => "Blend",
      :code => "Code",
      :unit => "Unit",
      :report => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Dep Name/)
    expect(rendered).to match(/Lab Name/)
    expect(rendered).to match(/Res Name/)
    expect(rendered).to match(/Kind/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/Onu/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Blend/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Unit/)
    expect(rendered).to match(//)
  end
end
