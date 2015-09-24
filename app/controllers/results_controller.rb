class ResultsController < ApplicationController

  def show
    result = Result.find(params[:id])
    error_messages = result.messages

    @learn_results = error_messages[0..2]
    @license_results = error_messages[3..4]
    @readme_results = error_messages[5..6]
    @contributing_results = error_messages[7..8]  

    @user = result.user
  end
end