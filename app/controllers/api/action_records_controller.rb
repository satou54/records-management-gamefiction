class Api::ActionRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @action_records = ActionRecord.all
  end

  def show
    @action_record = ActionRecord.find(params[:id])
  end

  def new
    @action_record = ActionRecord.new
  end

  def createOrUpdate
    # action_day,task_id,user_idと一致するデータが存在するかチェック
    @action_record = ActionRecord.find_by(action_day: params[:action_day],
                                          task_id: params[:task_id],
                                          user_id: params[:user_id])

    if (@action_record.nil?)
      # 一致するデータがない場合、createの処理を行う
      @action_record = ActionRecord.new(action_record_params)

      if @action_record.save
        render :index, status: :created
      else
        render json: @action_record.errors, status: :unprocessable_entity
      end
    else
      # 一致するデータがある場合、updateの処理を行う
      if @action_record.update(action_record_params)
        render :show, status: :ok
      else
        render json: @action_record.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def action_record_params
    params.fetch(:action_record, {}).permit(:action_day, :action,
                                            :action_experience_point, :user_id, :task_id)
  end
end
