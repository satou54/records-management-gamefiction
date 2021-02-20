class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token, if: :devise_controller?
  protect_from_forgery with: :null_session

  # ユーザのレベルアップとレベルダウン処理を行う
  def levelUpAndDown(task_id, action_day, action)

    # 各モデルのインスタンス作成
    task = Task.new
    action_record = ActionRecord.new
    user_level = UserLevel.new
    level_info = Level.new

    # task_idから目標を取得
    goal = task.getGoal(task_id)

    # 実績日をTime型に変換
    action_day = Time.parse(action_day)

    # 曜日を取得
    action_day_of_week = action_record.getDayOfTheWeek(action_day)

    # 曜日毎に1週間の範囲を取得
    action_day_of_the_week = action_record.getWeekRange(action_day, action_day_of_week)
    from = action_day_of_the_week[0]
    to = action_day_of_the_week[1]

    # 1週間の実績を配列で取得
    week_of_actions = action_record.weekOfActions(task_id, from, to)

    # 1週間の実績を合計
    week_of_action = week_of_actions.sum

    # 総経験値を取得
    total_experience_point = user_level.getTotalExperiencePoint(current_user.id)

    # レベルを取得
    level = user_level.getUserLevel(current_user.id)
    puts "level"
    puts level

    # 次レベルの経験値を取得
    next_level_required_experience_point = level_info.getRequreidExperiecePoint(level + 1)
    puts "next"
    puts next_level_required_experience_point

    # 既にデータが存在しているかチェック
    if (action_record.checkActionRecord?(action_day, task_id, current_user.id).nil?)
      # データが存在しない場合

      # 経験値を計算
      point = action_record.culcurateExperiencePoint(action, goal)

      # データ登録前にレベルアップ処理を行っているため
      week_of_action += action

      # 今回の追加分の前に目標を達成しているかチェック
      if ((week_of_action - action) < goal)
        #今回の追加分を含めた場合に目標を達成しているかチェック
        if (week_of_action >= goal)
          # 目標達成で経験値を追加
          point += 100
        end
      end

      # 今回獲得した経験値を足して新しい総経験値を計算
      total_experience_point += point

      # 総経験値が次レベルの必要経験値を上回ってる場合は処理に入る
      if (total_experience_point >= next_level_required_experience_point)

        # 総経験値が次レベルの必要経験値を下回るまでレベルアップする
        while total_experience_point >= next_level_required_experience_point
          level += 1
          next_level_required_experience_point = level_info.getRequreidExperiecePoint(level + 1)
        end

        # レベルアップ処理後のレベルを登録
        user_level.uploadUserLevel(current_user.id, level)
      end
    else
      # 一致するデータがある場合
      puts "修正"

      # 今回修正された実績と登録されている実績との差分を出す
      difference = action.to_f - @action_record.action.to_f
      puts "difference"
      puts difference

      # 修正により実績が増加した場合
      if (difference > 0)
        puts "修正により実績が増加した場合"
        # 差分と目標で経験値を算出
        point = action_record.culcurateExperiencePoint(difference, goal)
        puts "point"
        puts point

        puts "week_of_action"
        puts week_of_action

        # 今回の差分の前に目標に達しているかチェック
        if (week_of_action <= goal)
          puts "目標に達していない場合、今回の追加分で目標に達したかチェック"
          # 目標に達していない場合、今回の追加分で目標に達したかチェック
          if ((week_of_action + difference) >= goal)
            puts "今回の追加分で目標に達した場合は経験値を増加"
            # 今回の追加分で目標に達した場合は経験値を増加
            point += 100
          end
        end

        puts "チェック処理後"
        puts point

        # 今回獲得した経験値を足して新しい総経験値を計算
        total_experience_point += point
        puts "total"
        puts total_experience_point

        puts "next"
        puts next_level_required_experience_point

        # 現在の総経験値が次のレベルの必要経験値を上回っているかチェック
        if (total_experience_point >= next_level_required_experience_point)
          puts "総経験値が次レベルの必要経験値を上回ってる場合は処理に入る"
          puts level
          puts total_experience_point
          puts next_level_required_experience_point
          # 上回っている場合、総経験値が次のレベルの必要経験値を下回るまでレベルアップ処理を繰り返す
          while total_experience_point >= next_level_required_experience_point
            level += 1
            next_level_required_experience_point = level_info.getRequreidExperiecePoint(level + 1)
            puts "総経験値が次レベルの必要経験値を下回るまでレベルアップする"
            puts level
            puts total_experience_point
            puts next_level_required_experience_point
          end

          puts "繰り返し処理後"
          puts level
          puts total_experience_point
          puts next_level_required_experience_point

          # ユーザのレベルアップ処理後にレベルを登録
          user_level.uploadUserLevel(current_user.id, level)
        end
      else
        # 修正によりactionが減少した場合
        puts "修正によりactionが減少した場合"

        # 差分と目標から減少する経験値を計算
        point = action_record.culcurateExperiencePoint(difference, goal)
        puts "point"
        puts point

        puts "week_of_action"
        puts week_of_action
        puts "diffirence"
        puts difference

        # 今回の減少分で減少する前に目標を達しているかチェック
        if (week_of_action >= goal)
          puts "目標を達している場合、今回の減少分で割ったかチェック"
          # 目標を達してい場合、今回の減少分で割ったかチェック
          if ((week_of_action + difference) < goal)
            puts "今回の減少分で割っている場合は経験値を減少"
            # 今回の減少分で割っている場合は経験値を減少
            point -= 100
          end
        end

        puts "処理後のpoint"
        puts point

        # 今回の減少分の経験値を引いて新しい総経験値を計算
        total_experience_point += point
        puts "total"
        puts total_experience_point

        # 現在のレベルの必要経験値を取得
        current_level_required_experience_point = level_info.getRequreidExperiecePoint(level)
        puts "current"
        puts current_level_required_experience_point

        # 今回の減少分を含めた総経験値が現在のレベルの必要経験値を割っていないかチェック
        if (total_experience_point < current_level_required_experience_point)
          puts "必要経験値を割っている場合はレベルダウン後の必要経験値を割らなくなるまでレベルダウンを繰り返す"
          # 必要経験値を割っている場合はレベルダウン後の必要経験値を割らなくなるまでレベルダウンを繰り返す
          while total_experience_point < current_level_required_experience_point
            level -= 1
            current_level_required_experience_point = level_info.getRequreidExperiecePoint(level)
            puts "level"
            puts level
            puts "current"
            puts current_level_required_experience_point
          end

          puts "処理後"
          puts level
          puts current_level_required_experience_point

          # レベルダウン処理後のレベルを登録
          user_level.uploadUserLevel(current_user.id, level)
        end
      end
    end

    # 総経験値を登録
    user_level.uploadUserTotalExperiencePoint(current_user.id, total_experience_point)

    # 次のレベルアップに必要な経験値を計算する
    until_levelup = level_info.getNextLevelRequreidExperiencePoint(level, total_experience_point)

    # 配列を作って情報を返す
    levelup_data = {}
    levelup_data.store(:level, level)
    levelup_data.store(:total_experience_point, total_experience_point)
    levelup_data.store(:next_level_required_experience_point, next_level_required_experience_point)
    levelup_data.store(:until_levelup, until_levelup)
    levelup_data.store(:user_id, current_user.id)

    levelup_data
  end
end
