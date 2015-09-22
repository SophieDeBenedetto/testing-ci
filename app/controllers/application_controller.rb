class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_client, only: :event_handler

  def event_handler
    payload = JSON.parse(params[:payload])
    process_pull_request(payload)

    branch_name = payload["pull_request"]["head"]["ref"]
    repo_name = payload["pull_request"]["head"]["repo"]["full_name"]
    user = payload["pull_request"]["user"]["login"]
    full_repo = "http://www.github.com/#{repo_name}.git"
    root = Dir.pwd
    system "git clone #{full_repo} #{root}/app/cloned_repo/#{user}"
    system "git checkout #{branch_name}"
    
    results = LearnLinter.new("#{root}/app/cloned_repo/#{user}", "quiet").lint_directory

    # remove repo contents from app/cloned_repo
    system "rm -rf #{root}/app/cloned_repo/#{user}"
  end


  private
    def configure_client
      @client ||= Octokit::Client.new(:access_token => ENV['octo_token'])
    end

    def process_pull_request(payload)
      puts "Processing pull request..."
      binding.pry
      @client.create_status(payload["pull_request"]["head"]["repo"]["full_name"], payload["pull_request"]['head']['sha'], 'pending')
    end
end


    # grab the url + branch name from payload hash
    # clone it down onto the server(?)
    # run our LearnLinter.lint_directory(that dir, quiet)
    # use return value of ^^ to send something back to the repo/PR GUI
