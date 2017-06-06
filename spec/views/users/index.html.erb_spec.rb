require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Name",
        :last_name => "Last Name",
        :email => "Email",
        :password => "Password",
        :gender => "Gender",
        :place => "Place",
        :number => 2,
        :complement => "Complement",
        :cep => "Cep",
        :district => "District",
        :city => "City",
        :state => "State",
        :country => "Country",
        :phone => "Phone",
        :cell_phone => "Cell Phone",
        :kind => "Kind"
      ),
      User.create!(
        :name => "Name",
        :last_name => "Last Name",
        :email => "Email",
        :password => "Password",
        :gender => "Gender",
        :place => "Place",
        :number => 2,
        :complement => "Complement",
        :cep => "Cep",
        :district => "District",
        :city => "City",
        :state => "State",
        :country => "Country",
        :phone => "Phone",
        :cell_phone => "Cell Phone",
        :kind => "Kind"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "Place".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Complement".to_s, :count => 2
    assert_select "tr>td", :text => "Cep".to_s, :count => 2
    assert_select "tr>td", :text => "District".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Cell Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
  end
end
