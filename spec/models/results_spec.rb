require 'rails_helper'

RSpec.describe Results, :type => :model do
  
  let(:result) {Results.create(messages: [{message: "hey there"}], sha: "XXXXasd;lkcvasdfeoiawejghsdatestingwhatever", user: "Sophie" )}

  describe "attributes" do
    it "has an sha identifier" do
      expect(result.sha).to eq("XXXXasd;lkcvasdfeoiawejghsdatestingwhatever")
    end

    it "has a messages attributes that points to an array of message hashes" do 
      expect(result.messages).to be_a(Array)
    end

    it "has a user name" do 
      expect(result.user).to eq("Sophie")
    end
  end

end