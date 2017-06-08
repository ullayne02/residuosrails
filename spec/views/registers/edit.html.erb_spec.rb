require 'rails_helper'

RSpec.describe "registers/edit", type: :view do
  before(:each) do
    @register = assign(:register, Register.create!(
      :weight => 1.5,
      :residue => nil,
      :report => nil
    ))
  end

  it "renders the edit register form" do
    render

    assert_select "form[action=?][method=?]", register_path(@register), "post" do

      assert_select "input#register_weight[name=?]", "register[weight]"

      assert_select "input#register_residue_id[name=?]", "register[residue_id]"

      assert_select "input#register_report_id[name=?]", "register[report_id]"
    end
  end
end
