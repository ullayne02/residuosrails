require 'rails_helper'

RSpec.describe "notifications/edit", type: :view do
  before(:each) do
    @notification = assign(:notification, Notification.create!(
      :message => "MyString",
      :collection => nil,
      :request => nil
    ))
  end

  it "renders the edit notification form" do
    render

    assert_select "form[action=?][method=?]", notification_path(@notification), "post" do

      assert_select "input#notification_message[name=?]", "notification[message]"

      assert_select "input#notification_collection_id[name=?]", "notification[collection_id]"

      assert_select "input#notification_request_id[name=?]", "notification[request_id]"
    end
  end
end
