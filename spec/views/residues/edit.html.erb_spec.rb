require 'rails_helper'

RSpec.describe "residues/edit", type: :view do
  before(:each) do
    @residue = assign(:residue, Residue.create!(
      :name => "MyString",
      :kind => "MyString",
      :blend => "MyString",
      :onu => "MyString",
      :code => "MyString",
      :laboratory => nil,
      :collection => nil
    ))
  end

  it "renders the edit residue form" do
    render

    assert_select "form[action=?][method=?]", residue_path(@residue), "post" do

      assert_select "input#residue_name[name=?]", "residue[name]"

      assert_select "input#residue_kind[name=?]", "residue[kind]"

      assert_select "input#residue_blend[name=?]", "residue[blend]"

      assert_select "input#residue_onu[name=?]", "residue[onu]"

      assert_select "input#residue_code[name=?]", "residue[code]"

      assert_select "input#residue_laboratory_id[name=?]", "residue[laboratory_id]"

      assert_select "input#residue_collection_id[name=?]", "residue[collection_id]"
    end
  end
end
