class Api::ActionRecordsController < ApplicationController
  include Common, LevelUpDown, ActionRecordsReferences
  before_action :authenticate_user!

  def index
    @action_records = current_user.action_records
    puts "-----"
    puts "index"
  end

  def create
    action_record = ActionRecord.new(action_record_params)
    @levelup_data = levelUpAndDown(action_record_params[:task_id], action_record_params[:action_day], action_record_params[:action])
    if action_record.save
      @levelup_data.store(:action_record_id, action_record.id)
      render :registration, status: :ok
    else
      render json: { errors: action_record.errors.keys.map { |key| [key, action_record.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
    end
  end

  def update
    action_record = ActionRecord.find(action_record_params[:id])
    @levelup_data = levelUpAndDown(action_record_params[:task_id], action_record_params[:action_day], action_record_params[:action])
    if action_record.update(action_record_params)
      @levelup_data.store(:action_record_id, action_record.id)
      render :registration, status: :ok
    else
      render json: { errors: action_record.errors.keys.map { |key| [key, action_record.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
    end
  end

  def actionRecordReferences
    @references_data = getReferencesData(params[:interval])

    render :references, status: :ok
  end

  private

  def action_record_params
    params.fetch(:action_record, {}).permit(:id, :action_day, :action, :action_experience_point, :user_id, :task_id)
  end
end
