require 'rails_helper'

RSpec.describe "laboratories/new", type: :view do
  before(:each) do
    assign(:laboratory, Laboratory.new(
      :name => "MyString",
      :department => nil,
      :user => nil
    ))
  end

  it "renders new laboratory form" do
    render

    assert_select "form[action=?][method=?]", laboratories_path, "post" do

      assert_select "input#laboratory_name[name=?]", "laboratory[name]"

      assert_select "input#laboratory_department_id[name=?]", "laboratory[department_id]"

      assert_select "input#laboratory_user_id[name=?]", "laboratory[user_id]"
    end
  end
end
