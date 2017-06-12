require 'rails_helper'

RSpec.describe "reportregs/new", type: :view do
  before(:each) do
    assign(:reportreg, Reportreg.new(
      :weight => 1.5,
      :report => nil
    ))
  end

  it "renders new reportreg form" do
    render

    assert_select "form[action=?][method=?]", reportregs_path, "post" do

      assert_select "input#reportreg_weight[name=?]", "reportreg[weight]"

      assert_select "input#reportreg_report_id[name=?]", "reportreg[report_id]"
    end
  end
end
