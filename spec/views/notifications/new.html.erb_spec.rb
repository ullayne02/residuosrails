require 'rails_helper'

RSpec.describe "notifications/new", type: :view do
  before(:each) do
    assign(:notification, Notification.new(
      :message => "MyString",
      :collection => nil,
      :request => nil
    ))
  end

  it "renders new notification form" do
    render

    assert_select "form[action=?][method=?]", notifications_path, "post" do

      assert_select "input#notification_message[name=?]", "notification[message]"

      assert_select "input#notification_collection_id[name=?]", "notification[collection_id]"

      assert_select "input#notification_request_id[name=?]", "notification[request_id]"
    end
  end
end
