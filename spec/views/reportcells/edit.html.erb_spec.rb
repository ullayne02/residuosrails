require 'rails_helper'

RSpec.describe "reportcells/edit", type: :view do
  before(:each) do
    @reportcell = assign(:reportcell, Reportcell.create!(
      :dep_name => "MyString",
      :lab_name => "MyString",
      :res_name => "MyString",
      :kind => "MyString",
      :total => 1.5,
      :onu => "MyString",
      :state => "MyString",
      :blend => "MyString",
      :code => "MyString",
      :unit => "MyString",
      :report => nil
    ))
  end

  it "renders the edit reportcell form" do
    render

    assert_select "form[action=?][method=?]", reportcell_path(@reportcell), "post" do

      assert_select "input#reportcell_dep_name[name=?]", "reportcell[dep_name]"

      assert_select "input#reportcell_lab_name[name=?]", "reportcell[lab_name]"

      assert_select "input#reportcell_res_name[name=?]", "reportcell[res_name]"

      assert_select "input#reportcell_kind[name=?]", "reportcell[kind]"

      assert_select "input#reportcell_total[name=?]", "reportcell[total]"

      assert_select "input#reportcell_onu[name=?]", "reportcell[onu]"

      assert_select "input#reportcell_state[name=?]", "reportcell[state]"

      assert_select "input#reportcell_blend[name=?]", "reportcell[blend]"

      assert_select "input#reportcell_code[name=?]", "reportcell[code]"

      assert_select "input#reportcell_unit[name=?]", "reportcell[unit]"

      assert_select "input#reportcell_report_id[name=?]", "reportcell[report_id]"
    end
  end
end
