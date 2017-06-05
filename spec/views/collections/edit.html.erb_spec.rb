require 'rails_helper'

RSpec.describe "collections/edit", type: :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :max_value => 1.5,
      :report => "MyText"
    ))
  end

  it "renders the edit collection form" do
    render

    assert_select "form[action=?][method=?]", collection_path(@collection), "post" do

      assert_select "input#collection_max_value[name=?]", "collection[max_value]"

      assert_select "textarea#collection_report[name=?]", "collection[report]"
    end
  end
end
