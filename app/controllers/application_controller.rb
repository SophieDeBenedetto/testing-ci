class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def event_handler
    payload = JSON.parse(params[:payload])
    branch_name = payload["pull_request"]["head"]["ref"]
    repo_name = payload["pull_request"]["head"]["repo"]["full_name"]
    user = payload["pull_request"]["user"]["login"]
    full_repo = "http://www.github.com/#{repo_name}.git"
    root = Dir.pwd
    # binding.pry
    system "git clone #{full_repo} #{root}/app/cloned_repo/#{user}"
    system "git checkout #{branch_name}"
    
    LearnLinter.new("#{root}/app/cloned_repo/#{user}").lint_directory

    # remove repo contents from app/cloned_repo
    system "rm -rf #{root}/app/cloned_repo/#{user}"
  end
end


    # grab the url + branch name from payload hash
    # clone it down onto the server(?)
    # run our LearnLinter.lint_directory(that dir, quiet)
    # use return value of ^^ to send something back to the repo/PR GUI
