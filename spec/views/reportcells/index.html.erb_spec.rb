require 'rails_helper'

RSpec.describe "reportcells/index", type: :view do
  before(:each) do
    assign(:reportcells, [
      Reportcell.create!(
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
      ),
      Reportcell.create!(
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
      )
    ])
  end

  it "renders a list of reportcells" do
    render
    assert_select "tr>td", :text => "Dep Name".to_s, :count => 2
    assert_select "tr>td", :text => "Lab Name".to_s, :count => 2
    assert_select "tr>td", :text => "Res Name".to_s, :count => 2
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => "Onu".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Blend".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Unit".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
