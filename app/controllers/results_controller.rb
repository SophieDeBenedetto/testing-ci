class ResultsController < ApplicationController

  def show
    result = Results.find(params[:id])
    @error_messages = result.messages

  end
end