require "rails_helper"

RSpec.describe ReportcellsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reportcells").to route_to("reportcells#index")
    end

    it "routes to #new" do
      expect(:get => "/reportcells/new").to route_to("reportcells#new")
    end

    it "routes to #show" do
      expect(:get => "/reportcells/1").to route_to("reportcells#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reportcells/1/edit").to route_to("reportcells#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reportcells").to route_to("reportcells#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/reportcells/1").to route_to("reportcells#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reportcells/1").to route_to("reportcells#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reportcells/1").to route_to("reportcells#destroy", :id => "1")
    end

  end
end
