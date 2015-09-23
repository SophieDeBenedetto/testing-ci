class PullRequest

  attr_accessor :branch_name, :repo_name, :user, :full_repo, :repo_name, :root, :sha, :status, :description

  def initialize(params)
    payload = params["pull_request"]
    @branch_name = payload["head"]["ref"]
    @user = payload["user"]["login"]
    @repo_name = payload["head"]["repo"]["full_name"]
    @full_repo = "http://www.github.com/#{repo_name}.git"
    @sha = payload['head']['sha']
    @root = Dir.pwd
    @status = "pending"
    @description = {description: "pending"}
  end

  def validation_result(result=nil)
    case result
    when "failure"  
      self.status = "failure"
      self.description[:description] = "click the 'details' link for more info."
    when "success"
      self.status = "success"
      self.description[:description] = "passed all validations!"
    else
      self.status = "error"
      self.description[:description] = "click the 'details' link for more info."
    end
  end
end

