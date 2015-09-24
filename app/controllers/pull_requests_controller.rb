class PullRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  before_action :configure_pr, only: :event_handler
  after_action :remove_repo, only: :event_handler


  def event_handler
    process_pull_request
    @pull_request.set_status
    messages = @pull_request.set_messages
    @results = Results.find_or_create_by(messages: messages, sha: @pull_request.sha, user: @pull_request.user)
    process_pull_request(@result)
    
    redirect_to result_path(@results)

  end

  private

    def configure_pr
      configure_client
      set_pr
      add_repo
    end

    def configure_client
      @client ||= Octokit::Client.new(:access_token => ENV['octo_token'])
    end
    
    def set_pr
      @pull_request = PullRequest.new(params)
    end

    def add_repo
      system "git clone #{@pull_request.full_repo} #{@pull_request.root}/app/cloned_repo/#{@pull_request.user}"
      system "git checkout #{@pull_request.branch_name}"
    end

    def remove_repo
      system "rm -rf #{@pull_request.root}/app/cloned_repo/#{@pull_request.user}"
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

end