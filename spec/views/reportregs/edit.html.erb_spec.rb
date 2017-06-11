require 'rails_helper'

RSpec.describe "reportregs/edit", type: :view do
  before(:each) do
    @reportreg = assign(:reportreg, Reportreg.create!(
      :weight => 1.5,
      :report => nil
    ))
  end

  it "renders the edit reportreg form" do
    render

    assert_select "form[action=?][method=?]", reportreg_path(@reportreg), "post" do

      assert_select "input#reportreg_weight[name=?]", "reportreg[weight]"

      assert_select "input#reportreg_report_id[name=?]", "reportreg[report_id]"
    end
  end
end
