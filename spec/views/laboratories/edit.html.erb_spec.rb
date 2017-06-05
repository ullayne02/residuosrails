require 'rails_helper'

RSpec.describe "laboratories/edit", type: :view do
  before(:each) do
    @laboratory = assign(:laboratory, Laboratory.create!(
      :name => "MyString",
      :department => nil,
      :user => nil
    ))
  end

  it "renders the edit laboratory form" do
    render

    assert_select "form[action=?][method=?]", laboratory_path(@laboratory), "post" do

      assert_select "input#laboratory_name[name=?]", "laboratory[name]"

      assert_select "input#laboratory_department_id[name=?]", "laboratory[department_id]"

      assert_select "input#laboratory_user_id[name=?]", "laboratory[user_id]"
    end
  end
end
