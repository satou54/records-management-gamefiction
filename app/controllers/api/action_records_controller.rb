class Api::ActionRecordsController < ApplicationController
  def index
    @action_records = ActionRecord.all
  end

  def show
    @action_record = ActionRecord.find(params[:id])
  end

  def new
    @action_record = ActionRecord.new
  end

  def create
    @action_record = ActionRecord.new(action_record_params)

    if @action_record.save
      render :index, status: :created
    else
      render json: @action_record.errors, status: :unprocessable_entity
    end
  end

  private

  def action_record_params
    params.fetch(:action_record, {}).permit(:action_day, :action,
                                            :action_experience_point, :user_id, :task_id)
  end
end
