require "rails_helper"

RSpec.describe ReportregsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/reportregs").to route_to("reportregs#index")
    end

    it "routes to #new" do
      expect(:get => "/reportregs/new").to route_to("reportregs#new")
    end

    it "routes to #show" do
      expect(:get => "/reportregs/1").to route_to("reportregs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reportregs/1/edit").to route_to("reportregs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/reportregs").to route_to("reportregs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/reportregs/1").to route_to("reportregs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reportregs/1").to route_to("reportregs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reportregs/1").to route_to("reportregs#destroy", :id => "1")
    end

  end
end
