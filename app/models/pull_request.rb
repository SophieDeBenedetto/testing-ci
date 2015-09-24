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


  def set_status
    results = collect_results
    if results.all? {|result| result}
      self.validation_result("success")
    elsif results.all? {|result| !result}
      self.validation_result("failure")
    else
      self.validation_result
    end
  end

  def set_messages
    messages = @linter.result_message
    messages.collect do |message|
      message.delete_if {|k, v| k == :color}
    end
  end

  private

    def lint
      @linter = LearnLinter.new("#{self.root}/app/cloned_repo/#{self.user}", "quiet")
      @linter.lint_directory
    end

    def collect_results
      lint.collect do |file, attributes|
        attributes.collect do |attr, value|
          value
        end
      end.flatten!
    end

    def validation_result(result=nil)
      case result
      when "failure"  
        self.status = "failure"
        self.description[:description] = "failed all validations, click the 'details' link for more info."
      when "success"
        self.status = "success"
        self.description[:description] = "passed all validations!"
      else
        self.status = "error"
        self.description[:description] = "failing some validations, click the 'details' link for more info."
      end
    end
end

