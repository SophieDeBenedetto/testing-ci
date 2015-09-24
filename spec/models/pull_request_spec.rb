require 'rails_helper'

RSpec.describe PullRequest, :type => :model do
  

  describe "#set_status" do
    before do 
      stubbed_params = configure_pr_content
      @pull_reques = PullRequest.new(stubbed_params)
      add_test_repo(@pull_request)
    end
    
    it "sets the status and description to error when some validations fail" do
      pull_request.set_status
      expect(@pull_request.status).to eq("failure")
      expect(@pull_request.description).to eq({description: "failing some validations, click the 'details' link for more info."})
    end
  
  end
end
