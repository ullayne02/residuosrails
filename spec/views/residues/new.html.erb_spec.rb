require 'rails_helper'

RSpec.describe "residues/new", type: :view do
  before(:each) do
    assign(:residue, Residue.new(
      :name => "MyString",
      :kind => "MyString",
      :blend => "MyString",
      :onu => "MyString",
      :code => "MyString",
      :laboratory => nil,
      :collection => nil
    ))
  end

  it "renders new residue form" do
    render

    assert_select "form[action=?][method=?]", residues_path, "post" do

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
