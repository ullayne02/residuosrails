require 'rails_helper'

RSpec.describe "reports/new", type: :view do
  before(:each) do
    assign(:report, Report.new(
      :generate_by => 1,
      :unit => false,
      :state => false,
      :kind => false,
      :onu => false,
      :blend => false,
      :code => false,
      :total => false,
      :collection => nil
    ))
  end

  it "renders new report form" do
    render

    assert_select "form[action=?][method=?]", reports_path, "post" do

      assert_select "input#report_generate_by[name=?]", "report[generate_by]"

      assert_select "input#report_unit[name=?]", "report[unit]"

      assert_select "input#report_state[name=?]", "report[state]"

      assert_select "input#report_kind[name=?]", "report[kind]"

      assert_select "input#report_onu[name=?]", "report[onu]"

      assert_select "input#report_blend[name=?]", "report[blend]"

      assert_select "input#report_code[name=?]", "report[code]"

      assert_select "input#report_total[name=?]", "report[total]"

      assert_select "input#report_collection_id[name=?]", "report[collection_id]"
    end
  end
end
