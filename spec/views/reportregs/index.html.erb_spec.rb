require 'rails_helper'

RSpec.describe "reportregs/index", type: :view do
  before(:each) do
    assign(:reportregs, [
      Reportreg.create!(
        :weight => 2.5,
        :report => nil
      ),
      Reportreg.create!(
        :weight => 2.5,
        :report => nil
      )
    ])
  end

  it "renders a list of reportregs" do
    render
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
