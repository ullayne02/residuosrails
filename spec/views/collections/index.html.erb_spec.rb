require 'rails_helper'

RSpec.describe "collections/index", type: :view do
  before(:each) do
    assign(:collections, [
      Collection.create!(
        :max_value => 2.5,
        :report => "MyText"
      ),
      Collection.create!(
        :max_value => 2.5,
        :report => "MyText"
      )
    ])
  end

  it "renders a list of collections" do
    render
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
