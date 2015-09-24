class ResultsController < ApplicationController

  def show
    result = Result.find(params[:id])
    @error_messages = result.messages
    @user = result.user
  end
end