require 'rails_helper'

RSpec.describe "reportregs/show", type: :view do
  before(:each) do
    @reportreg = assign(:reportreg, Reportreg.create!(
      :weight => 2.5,
      :report => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(//)
  end
end
