require 'rails_helper'

RSpec.describe "Reportcells", type: :request do
  describe "GET /reportcells" do
    it "works! (now write some real specs)" do
      get reportcells_path
      expect(response).to have_http_status(200)
    end
  end
end
