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

    # task_idからtaskのgoalを取得
    # goal = Task.find(action_record_params[:task_id]).goal
    goal = getGoal(action_record_params[:task_id])

    # 追加した日を取得してTime型に変換
    action_day = Time.parse(action_record_params[:action_day])

    # 曜日を取得。日-土が0-6で取得できる
    # action_day_of_the_week = action_day.wday
    action_day_of_the_week = getDayOfTheWeek

    # 曜日毎に1週間の範囲を取得
    # from...toの場合toは指定した日を含まないため、日曜日ではなく月曜日を指定している
    =begin
    case action_day_of_the_week
    # 日曜日
    when 0 then
      from = (action_day - 6.day).at_beginning_of_day
      to = (action_day + 1.day).at_beginning_of_day
    # 月曜日
    when 1 then
      from = action_day.at_beginning_of_day
      to = (action_day + 7.day).at_beginning_of_day
    # 火曜日
    when 2 then
      from = (action_day - 1.day).at_beginning_of_day
      to = (action_day + 6.day).at_beginning_of_day
    # 水曜日
    when 3 then
      from = (action_day - 2.day).at_beginning_of_day
      to = (action_day + 5.day).at_beginning_of_day
    # 木曜日
    when 4 then
      from = (action_day - 3.day).at_beginning_of_day
      to = (action_day + 4.day).at_beginning_of_day
    # 金曜日
    when 5 then
      from = (action_day - 4.day).at_beginning_of_day
      to = (action_day + 3.day).at_beginning_of_day
    # 土曜日
    when 6 then
      from = (action_day - 5.day).at_beginning_of_day
      to = (action_day + 2.day).at_beginning_of_day
    end
    =end

    # 複数の戻り値を取得する方法は後で調べる
    from...to = getDayOfTheWeek

    # １週間の実績を配列で取得
    # week_of_actions = ActionRecord.where(task_id: action_record_params[:task_id])
    #                  .where(action_day: from...to).select(:action).pluck(:action)
    week_of_actions = weekOfActions(action_record_params[:task_id], from, to)

    # 1週間の実績の合計
    week_of_action = week_of_actions.sum

    # user_levelsテーブルの総経験値を取得
    # total_experience_point = UserLevel.find_by(user_id: current_user.id).total_experience_point
    total_experience_point = getTotalExperiencePoint(current_user.id)

    # userのlevelを取得
    # level = UserLevel.find_by(user_id: current_user.id).level
    getUserLevel(current_user.id)

    # levelテーブルの次のレベルの経験値を取得
    # next_level_required_experience_point = Level.find_by(level: (level+1)).required_experience_point
    next_level_required_experience_point = getRequreidExperiecePoint(level+1)
    
    if (@action_record.nil?)
      # 一致するデータがない場合、createの処理を行う
      @action_record = ActionRecord.new(action_record_params)

      if @action_record.save
        render :index, status: :created

        # 登録後にレベルアップ処理を行う

        # actionとgoalを比較して経験値を算出
        # 目標に対する実績の割合が1%で経験値1増える
        # point = (action_record_params[:action].to_f / goal.to_f * 100).floor
        point = culcurateExperiencePoint(action_record_params[:action], goal)

        # 今回の追加分の前に目標を達成しているかチェック
        if ((week_of_action - action_record_params[:action]) < goal)
          puts "今回の追加分までに目標未達成"
          #今回の追加分を含めて目標を達成しているかチェック
          if (week_of_action >= goal)
            puts "今回の追加分で目標達成!"
            # 目標達成で+100の経験値を追加
            point += 100
          end
        end

        # 今回獲得した経験値を足して新しい総経験値を計算
        total_experience_point += point

        # 総経験値が次レベルの必要経験値を上回ってる場合は処理に入る
        if (total_experience_point >= next_level_required_experience_point) 
          # 総経験値が次レベルの必要経験値を下回るまでレベルアップする
          while total_experience_point >= next_level_required_experience_point
            puts "レベルアップ"
            level += 1
            # next_level_required_experience_point = Level.find_by(level: (level+1)).required_experience_point
            next_level_required_experience_point = getRequreidExperiecePoint(level+1)
          end

          # ユーザのレベルアップ後のレベルをuser_levelsに登録
          puts "level_after"
          # user  = UserLevel.find_by(user_id: current_user.id)
          # user.update_attribute("level", level)
          uploadUserLevel(current_user.id, level)
        end

        # 今回の経験値を追加した総経験値をuser_levelsテーブルに追加
        # user_level = UserLevel.find_by(user_id: current_user.id)
        # user_level.update_attribute("total_experience_point", total_experience_point)
        uploadUserTotalExperiencePoint(current_user.id, total_experience_point)

        # 次のレベルアップまでの必要経験値を計算する
        next_level_required_experience_point = getRequreidExperiecePoint(level+1)
        until_levelup = next_level_required_experience_point - total_experience_point

        # 配列を作って情報を返す
        levelup_data = {}
        levelup_data.store(:level, level)
        levelup_data.store(:total_experience_point, total_experience_point)
        levelup_data.store(:next_level_required_experience_point, next_level_required_experience_point)
        levelup_data.store(:until_levelup, until_levelup)

        puts "levelup_data"
        puts levelup_data

      else
        render json: @action_record.errors, status: :unprocessable_entity
      end
    else
      # 一致するデータがある場合、updateの処理を行う
      if @action_record.update(action_record_params)
        render :show, status: :ok

        # 修正後にレベルアップ処理を行う

        # 今回修正されたactionとDBに登録されているactionとの差分を出す
        difference = action_record_params[:action].to_f - @action_record.action.to_f

        # 差分から今回の修正で増加か減少かで条件分岐

        # 修正によりactionが増加した場合
        if (difference > 0)
          # 差分とgoalで経験値を算出
          point = (difference.to_f / goal.to_f * 100).floor
          # 今回の差分の前に目標に達しているかチェック
          if ((week_of_action - action_record_params[:action]) < goal)
            # 目標に達していない場合、今回の追加分で目標に達したかチェック
            if (week_of_action >= goal)
              # 今回の追加分で目標に達した場合は経験値を+100
              point += 100
            end
          end

          # 今回獲得した経験値を足して新しい総経験値を計算
          total_experience_point += point

          # 現在の総経験値が次のレベルの必要経験値を上回っているかチェック
          if (total_experience_point >= next_level_required_experience_point)  
            # 上回っている場合、総経験値が次のレベルの必要経験値を下回るまでレベルアップ処理を繰り返す
            while total_experience_point >= next_level_required_experience_point
            # レベルアップの繰り返し処理終了後にusers_levelsテーブルにレベルを登録
              puts "レベルアップ"
              level += 1
              # next_level_required_experience_point = Level.find_by(level: (level+1)).required_experience_point
              next_level_required_experience_point = getRequreidExperiecePoint(level+1)
            end
          
          # ユーザのレベルアップ処理後にユーザのレベルをuser_levelsテーブルに保存
            #user  = UserLevel.find_by(user_id: current_user.id)
            #user.update_attribute("level", level)
            uploadUserLevel(current_user.id, lelvel)
          puts 

          # 先ほど計算した今回の追加分を含めた総経験値をuser_levelsテーブルに登録
          # user_level = UserLevel.find_by(user_id: current_user.id)
          # user_level.update_attribute("total_experience_point", total_experience_point)
          uploadUserTotalExperiencePoint(current_user.id, total_experience_point)
          
          # 次のレベルアップまでに必要な経験値を計算する
          # next_level_required_experience_point = Level.find_by(level: (level+1)).required_experience_point
          next_level_required_experience_point = getRequreidExperiecePoint(level+1)
          until_levelup = next_level_required_experience_point - total_experience_point

          # 配列を作って返す
          levelup_data = {}
          levelup_data.store(:level, level)
          levelup_data.store(:total_experience_point, total_experience_point)
          levelup_data.store(:next_level_required_experience_point, next_level_required_experience_point)
          levelup_data.store(:until_levelup, until_levelup)

          puts "levelup_data"
          puts levelup_data
        else
        # 修正によりactionが減少した場合
          # 差分とgoalから減少分の経験値を算出
          point = (difference.to_f / goal.to_f * 100).floor
          # 今回の減少分で減少する前に目標を達しているかチェック
          if ((week_of_action - action_record_params[:action]) > goal)
            # 目標を達してい場合、今回の減少分で割ったかチェック
            if (week_of_action < goal)
              # 今回の減少分で割っている場合、経験値を-100
              point -= 100
            end
          end
          # 今回の減少分の経験値を引いて新しい総経験値を計算
          total_experience_point += 100

          # 現在のレベルの必要経験値を取得
          # current_level_required_experience_point = Level.find_by(level: level).required_experience_point
          current_level_required_experience_point = getRequreidExperiecePoint(level)
          # 今回の減少分を含めた総経験値が現在のレベルの必要経験値を割っていないかチェック
          if (total_experience_point < current_level_required_experience_point)
            # 必要経験値を割っている場合はレベルダウン後の必要経験値を割らなくなるまでレベルダウンを繰り返す
            while total_experience_point >=  current_level_required_experience_point
              puts "レベルダウン"
              level -= 1
              # current_level_required_experience_point = Level.find_by(level: level).required_experience_point
              current_level_required_experience_point = getRequreidExperiecePoint(level)
            end
          # 処理後のレベルをuser_levelsテーブルに保存
          # user  = UserLevel.find_by(user_id: current_user.id)
          # user.update_attribute("level", level)
          uploadUserLevel(current_user.id, level)

          # 減少後の総経験値をuser_levelsテーブルに保存
          # user_level = UserLevel.find_by(user_id: current_user.id)
          # user_level.update_attribute("total_experience_point", total_experience_point)
          uploadUserTotalExperiencePoint(current_user.id, total_experience_point)

          # 次のレベルアップに必要な経験値を計算する
          # next_level_required_experience_point = Level.find_by(level: (level+1)).required_experience_point
          next_level_required_experience_point = getRequreidExperiecePoint(level+1)
          until_levelup = next_level_required_experience_point - total_experience_point

          # 配列を作って返す
          levelup_data = {}
          levelup_data.store(:level, level)
          levelup_data.store(:total_experience_point, total_experience_point)
          levelup_data.store(:next_level_required_experience_point, next_level_required_experience_point)
          levelup_data.store(:until_levelup, until_levelup)
        end

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
