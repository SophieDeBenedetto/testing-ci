require 'rails_helper'

RSpec.describe PullRequestsController, :type => :controller do
  
  describe "POST event_handler with PR status open" do
    describe "with valid params" do
      it "sends a payload" do
        stubbed_params = configure_pr_content["pull_request"]
        
        post :event_handler, {:pull_request => stubbed_params}, {}
        
        expect(response.status).to eq(302)
      end
    end
  end

  describe "POST event_handler with PR status closed" do
    describe "" do

    end
  end
end