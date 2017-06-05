require "rails_helper"

RSpec.describe ResiduesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/residues").to route_to("residues#index")
    end

    it "routes to #new" do
      expect(:get => "/residues/new").to route_to("residues#new")
    end

    it "routes to #show" do
      expect(:get => "/residues/1").to route_to("residues#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/residues/1/edit").to route_to("residues#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/residues").to route_to("residues#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/residues/1").to route_to("residues#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/residues/1").to route_to("residues#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/residues/1").to route_to("residues#destroy", :id => "1")
    end

  end
end
