require 'rails_helper'

RSpec.describe "registers/show", type: :view do
  before(:each) do
    @register = assign(:register, Register.create!(
      :weight => 2.5,
      :residue => nil,
      :report => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
