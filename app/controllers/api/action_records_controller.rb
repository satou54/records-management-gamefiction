class Api::ActionRecordsController < ApplicationController
  before_action :authenticate_user!
  # １週間
  WEEK = 7
  # 確率
  PERCENT = 100

  def index
    @action_records = current_user.action_records
  end

  def createOrUpdate
    # action_day,task_id,user_idと一致するデータが存在するかチェック
    @action_record = ActionRecord.find_by(action_day: action_record_params[:action_day],
                                          task_id: action_record_params[:task_id],
                                          user_id: action_record_params[:user_id])

    # レベル処理を行う
    levelup_data = levelUpAndDown(action_record_params[:task_id], action_record_params[:action_day], action_record_params[:action])

    if (@action_record.nil?)
      @action_record = ActionRecord.new(action_record_params)

      if @action_record.save
        render :show, status: :created
      else
        render json: { errors: @action_record.errors.keys.map { |key| [key, @action_record.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
      end
    else
      if @action_record.update(action_record_params)
        render :show, status: :ok
      else
        render json: { errors: @action_record.errors.keys.map { |key| [key, @action_record.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
      end
    end
  end

  def actionRecordReferences
    # paramsに入れた期間の値を受け取る
    interval = params[:interval]

    # intervalの値に応じてform...toを取得
    case interval
    when "thisWeek"
      action_record = ActionRecord.new
      today = Time.now
      day_of_week = action_record.getDayOfTheWeek(today)
      range_of_week = action_record.getWeekRange(today, day_of_week)
      from = range_of_week[0]
      to = range_of_week[1]
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

      # タスクのidからデータを取得
      task = Task.find(id)

      # タスクの名前を変数に代入
      task_name = task.task

      # 期間内の日数を計算
      days = Date.parse(to.to_s) - Date.parse(from.to_s)

      # 期間内の目標の合計値を変数に代入
      total_goal = (task.goal * days.to_i / WEEK).floor(1).to_f

      # 目標の単位を取得
      unit = task.unit

      # 期間内の実績の合計値を配列に代入
      total_actions = ActionRecord.where(task_id: id)
        .where(action_day: from...to).select(:action)
        .pluck(:action)

      # 配列を合計して総実績を取得
      total_actions = total_actions.sum

      # 達成度を計算し変数に代入
      achievement_rate = (total_actions.to_f / total_goal.to_f * PERCENT).floor(1).to_f

      task_data.store(:task, task_name)
      task_data.store(:total_goal, total_goal)
      task_data.store(:unit, unit)
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
    params.fetch(:action_record, {}).permit(:action_day, :action, :action_experience_point, :user_id, :task_id)
  end
end
