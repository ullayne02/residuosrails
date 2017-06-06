require 'rails_helper'

RSpec.describe "collections/new", type: :view do
  before(:each) do
    assign(:collection, Collection.new(
      :max_value => 1.5,
      :report => "MyText"
    ))
  end

  it "renders new collection form" do
    render

    assert_select "form[action=?][method=?]", collections_path, "post" do

      assert_select "input#collection_max_value[name=?]", "collection[max_value]"

      assert_select "textarea#collection_report[name=?]", "collection[report]"
    end
  end
end
