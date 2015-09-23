class PullRequest

  attr_accessor :branch_name, :repo_name, :user, :full_repo, :root, :sha, :status

  def initialize(params)
    payload = JSON.parse(params[:payload])
    @branch_name = payload["pull_request"]["head"]["ref"]
    @user = payload["pull_request"]["user"]["login"]
    @repo_name = payload["pull_request"]["head"]["repo"]["full_name"]
    @full_repo = "http://www.github.com/#{repo_name}.git"
    @sha = payload["pull_request"]['head']['sha']
    @root = Dir.pwd
    @status = "pending"
  end

  

end

