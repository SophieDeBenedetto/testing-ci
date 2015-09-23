class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_client, only: :event_handler
  before_action :add_repo, only: :event_handler
  after_action :remove_repo, only: :event_handler

  def event_handler
    process_pull_request(@pull_request)
    set_status(@pull_request)
    process_pull_request(@pull_request)
  end


  private

    def set_pr
      @pull_request = PullRequest.new(params)
    end

    def configure_client
      @client ||= Octokit::Client.new(:access_token => ENV['octo_token'])
    end

    def process_pull_request(pull_request, description=nil)
      puts "Processing pull request..."
      description = {description: "hiya"}
      binding.pry
      @client.create_status(pull_request.repo_name, pull_request.sha, pull_request.status, description)
    end

    def add_repo
      set_pr
      system "git clone #{@pull_request.full_repo} #{@pull_request.root}/app/cloned_repo/#{@pull_request.user}"
      system "git checkout #{@pull_request.branch_name}"
    end

    def lint_directory(pull_request)
      LearnLinter.new("#{pull_request.root}/app/cloned_repo/#{pull_request.user}", "quiet").lint_directory
    end

    def remove_repo
      system "rm -rf #{@pull_request.root}/app/cloned_repo/#{@pull_request.user}"
    end


    def set_status(pull_request)
      results = lint_directory(pull_request)
      results.collect do |file, attributes|
        attributes.collect do |attribute, value| 
          unless value
            pull_request.status = "failure"
            break
          end
        end
      end
    end
end