require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :password => "MyString",
      :gender => "MyString",
      :place => "MyString",
      :number => 1,
      :complement => "MyString",
      :cep => "MyString",
      :district => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString",
      :phone => "MyString",
      :cell_phone => "MyString",
      :kind => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "input#user_password[name=?]", "user[password]"

      assert_select "input#user_gender[name=?]", "user[gender]"

      assert_select "input#user_place[name=?]", "user[place]"

      assert_select "input#user_number[name=?]", "user[number]"

      assert_select "input#user_complement[name=?]", "user[complement]"

      assert_select "input#user_cep[name=?]", "user[cep]"

      assert_select "input#user_district[name=?]", "user[district]"

      assert_select "input#user_city[name=?]", "user[city]"

      assert_select "input#user_state[name=?]", "user[state]"

      assert_select "input#user_country[name=?]", "user[country]"

      assert_select "input#user_phone[name=?]", "user[phone]"

      assert_select "input#user_cell_phone[name=?]", "user[cell_phone]"

      assert_select "input#user_kind[name=?]", "user[kind]"
    end
  end
end
