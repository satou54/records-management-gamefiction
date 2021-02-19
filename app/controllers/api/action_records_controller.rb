class Api::ActionRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @action_records = current_user.action_records
  end

  def show
    @action_record = ActionRecord.find(params[:id])
  end

  def new
    @action_record = ActionRecord.new
  end

  def createOrUpdate
    # action_day,task_id,user_idと一致するデータが存在するかチェック
    @action_record = ActionRecord.find_by(action_day: action_record_params[:action_day],
                                          task_id: action_record_params[:task_id],
                                          user_id: action_record_params[:user_id])

    if (@action_record.nil?)
      @action_record = ActionRecord.new(action_record_params)

      if @action_record.save
        # レベル処理を行う
        levelUpAndDown(action_record_params[:task_id], action_record_params[:action_day], action_record_params[:action])

        render :index, status: :created
      else
        render json: @action_record.errors, status: :unprocessable_entity
      end
    else
      if @action_record.update(action_record_params)
        # レベル処理を行う
        evelUpAndDown(action_record_params[:task_id], action_record_params[:action_day], action_record_params[:action])

        render :show, status: :ok
      else
        render json: @action_record.errors, status: :unprocessable_entity
      end
    end
  end

  def actionRecordReferences
    # paramsに入れた期間の値を受け取る
    interval = params[:interval]

    # form...toの場合、toの日付は含まれないため指定する範囲の翌日をtoに指定する
    case interval
    when "thisMonth"
      from = Time.now.beginning_of_month
      to = Time.now.next_month.beginning_of_month
    when "lastMonth"
      from = Time.now.prev_month.beginning_of_month
      to = Time.now.beginning_of_month
    when "lastThreeMonth"
      from = Time.now.ago(3.month).beginning_of_month
      to = Time.now.next_month.beginning_of_month
    when "lastSixMonth"
      from = Time.now.ago(6.month).beginning_of_month
      to = Time.now.next_month.beginning_of_month
    end

    # ユーザのtask_idを配列に入れる
    tasks_ids = current_user.tasks.ids

    # 参照されるデータ一覧
    @references_data = []

    tasks_ids.each do |id|
      # タスク毎のハッシュを作成
      task_data = {}

      # タスクの名前を変数に代入
      task_name = Task.find(id).task

      # 期間内の日数を計算
      days = Date.parse(to.to_s) - Date.parse(from.to_s)

      # 期間内の目標の合計値を変数に代入
      total_goal = Task.find(id).goal * days.to_i

      # 期間内の実績の合計値を変数に代入
      total_actions = ActionRecord.where(task_id: id)
        .where(action_day: from...to).select(:action)
        .pluck(:action)
      total_actions = total_actions.sum

      # 達成度を計算し変数に代入
      achievement_rate = (total_actions.to_f / total_goal.to_f * 100).floor(1).to_f

      task_data.store(:task, task_name)
      task_data.store(:total_goal, total_goal)
      task_data.store(:total_action, total_actions)
      task_data.store(:achievement_rate, achievement_rate)

      # タスクのハッシュを参照用の配列に追加
      @references_data.push(task_data)
    end

    # 作成した連想配列を返す
    render :references, status: :ok
  end

  private

  def action_record_params
    params.fetch(:action_record, {}).permit(:action_day, :action,
                                            :action_experience_point, :user_id, :task_id)
  end
end
