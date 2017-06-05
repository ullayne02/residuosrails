require 'rails_helper'

RSpec.describe "Residues", type: :request do
  describe "GET /residues" do
    it "works! (now write some real specs)" do
      get residues_path
      expect(response).to have_http_status(200)
    end
  end
end
