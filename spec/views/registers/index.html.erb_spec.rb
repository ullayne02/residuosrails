require 'rails_helper'

RSpec.describe "registers/index", type: :view do
  before(:each) do
    assign(:registers, [
      Register.create!(
        :weight => 2.5,
        :residue => nil
      ),
      Register.create!(
        :weight => 2.5,
        :residue => nil
      )
    ])
  end

  it "renders a list of registers" do
    render
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
