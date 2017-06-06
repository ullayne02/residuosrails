require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/Place/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Complement/)
    expect(rendered).to match(/Cep/)
    expect(rendered).to match(/District/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Cell Phone/)
    expect(rendered).to match(/Kind/)
  end
end
