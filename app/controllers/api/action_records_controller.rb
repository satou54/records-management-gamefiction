class Api::ActionRecordsController < ApplicationController
  def index
    @action_records = ActionRecord.all
  end

  def show
    @action_record = ActionRecord.find(params[:id])
  end
end
