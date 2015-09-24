require 'rails_helper'

RSpec.describe Result, :type => :model do
  
  let(:result) {Result.create(messages: [{message: "hey there"}], pr_id: "45679127", user: "Sophie" )}

  describe "attributes" do
    it "has an pr_id identifier" do
      expect(result.pr_id).to eq("45679127")
    end

    it "has a messages attributes that points to an array of message hashes" do 
      expect(result.messages).to be_a(Array)
    end

    it "has a user name" do 
      expect(result.user).to eq("Sophie")
    end
  end

end