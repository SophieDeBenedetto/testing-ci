require 'rails_helper'

RSpec.describe PullRequestsController, :type => :controller do
  
  describe "POST event_handler with PR status open" do

    it "sends a payload" do
      stubbed_params = configure_pr_open["pull_request"]
      
      post :event_handler, {:pull_request => stubbed_params}, {}
      
      expect(response.status).to eq(302)
    end

  end

  describe "POST event_handler with PR status closed" do

    it "id should not be in database " do
      stubbed_params = configure_pr_closed["pull_request"]

      post :event_handler, {:pull_request => stubbed_params}, {}

      expect(Results.where("pr_id = '?'", stubbed_params['id'])).to eq([])
    end

  end

end