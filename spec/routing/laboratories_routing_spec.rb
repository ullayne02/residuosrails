require "rails_helper"

RSpec.describe LaboratoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/laboratories").to route_to("laboratories#index")
    end

    it "routes to #new" do
      expect(:get => "/laboratories/new").to route_to("laboratories#new")
    end

    it "routes to #show" do
      expect(:get => "/laboratories/1").to route_to("laboratories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/laboratories/1/edit").to route_to("laboratories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/laboratories").to route_to("laboratories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/laboratories/1").to route_to("laboratories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/laboratories/1").to route_to("laboratories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/laboratories/1").to route_to("laboratories#destroy", :id => "1")
    end

  end
end
