class Api::ActionRecordsController < ApplicationController
  include Common, LevelUpDown, ActionRecordsReferences
  before_action :authenticate_user!

  def index
    @action_records = current_user.action_records
  end

  def createOrUpdate
    # action_day,task_id,user_idと一致するデータが存在するかチェック
    @action_record = ActionRecord.find_by(action_day: action_record_params[:action_day],
                                          task_id: action_record_params[:task_id],
                                          user_id: action_record_params[:user_id])

    # レベル処理を行う
    @levelup_data = levelUpAndDown(action_record_params[:task_id], action_record_params[:action_day], action_record_params[:action])

    if (@action_record.nil?)
      @action_record = ActionRecord.new(action_record_params)

      if @action_record.save
        render :registration, status: :created
      else
        render json: { errors: @action_record.errors.keys.map { |key| [key, @action_record.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
      end
    else
      if @action_record.update(action_record_params)
        render :registration, status: :ok
      else
        render json: { errors: @action_record.errors.keys.map { |key| [key, @action_record.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
      end
    end
  end

  def actionRecordReferences
    @references_data = getReferencesData(params[:interval])

    # 作成した連想配列を返す
    render :references, status: :ok
  end

  private

  def action_record_params
    params.fetch(:action_record, {}).permit(:action_day, :action, :action_experience_point, :user_id, :task_id)
  end
end
