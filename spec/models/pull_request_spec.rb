require 'rails_helper'

RSpec.describe PullRequest, :type => :model do
  

  describe "#set_status" do
    before do 
      stubbed_params = configure_pr_open
      @pull_request = PullRequest.new(stubbed_params)
      add_test_repo(@pull_request)
    end

    after do 
      remove_test_repo(@pull_request)
    end
    
    it "sets the status and description to error when some validations fail" do
      @pull_request.set_status
      expect(@pull_request.status).to eq("error")
      expect(@pull_request.description).to eq("failing some validations, click the 'details' link for more info.")
    end
  
  end
end
