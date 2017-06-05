require 'rails_helper'

RSpec.describe "Laboratories", type: :request do
  describe "GET /laboratories" do
    it "works! (now write some real specs)" do
      get laboratories_path
      expect(response).to have_http_status(200)
    end
  end
end
