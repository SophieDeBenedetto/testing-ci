class ResultsController < ApplicationController

  def show
    results = Results.find(params[:id])
    @error_messages = results.messages
    @user = results.user
  end
end