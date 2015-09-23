class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  
  before_action :configure_pr, only: :event_handler
  after_action :remove_repo, only: :event_handler


  def event_handler
    process_pull_request
    set_status
    messages = set_messages
    @result = Results.create(messages: messages)
    process_pull_request(@result)
    
    redirect_to result_path(@result)

  end

  def results
    result = Result.find_by(params[:id])
    @error_message = result
    render "results"
  end

  private

    def set_messages
      messages = @linter.result_message
      messages.collect do |message|
        message.delete_if {|k, v| k == :color}
      end
    end

    def configure_pr
      configure_client
      set_pr
      add_repo
    end

    def set_pr
      @pull_request = PullRequest.new(params)
    end

    def configure_client
      @client ||= Octokit::Client.new(:access_token => ENV['octo_token'])
    end

    def process_pull_request(result=nil)
      puts "Processing pull request..."
      if result
        info = {description: @pull_request.description, target_url: "http://0c143c01.ngrok.io/results/#{result.id}"}
      else
        info = {description: @pull_request.description}
      end
      @client.create_status(@pull_request.repo_name, @pull_request.sha, @pull_request.status, info)
    end

    def add_repo
      system "git clone #{@pull_request.full_repo} #{@pull_request.root}/app/cloned_repo/#{@pull_request.user}"
      system "git checkout #{@pull_request.branch_name}"
    end

    def lint_directory
      @linter = LearnLinter.new("#{@pull_request.root}/app/cloned_repo/#{@pull_request.user}", "quiet")
      @linter.lint_directory
    end

    def remove_repo
      system "rm -rf #{@pull_request.root}/app/cloned_repo/#{@pull_request.user}"
    end

    def collect_results
      lint_directory.collect do |file, attributes|
        attributes.collect do |attr, value|
          value
        end
      end.flatten!
    end

    def set_status
      results = collect_results

      if results.all? {|result| result}
        @pull_request.validation_result("success")
      elsif results.all? {|result| !result}
        @pull_request.validation_result("failure")
      else
        @pull_request.validation_result
      end
    end
end