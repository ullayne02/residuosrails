require 'rails_helper'

RSpec.describe "requests/new", type: :view do
  before(:each) do
    assign(:request, Request.new(
      :user => nil,
      :laboratory => nil
    ))
  end

  it "renders new request form" do
    render

    assert_select "form[action=?][method=?]", requests_path, "post" do

      assert_select "input#request_user_id[name=?]", "request[user_id]"

      assert_select "input#request_laboratory_id[name=?]", "request[laboratory_id]"
    end
  end
end
