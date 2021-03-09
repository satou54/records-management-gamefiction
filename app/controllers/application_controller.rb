class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Common
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  # 目標達成時の経験値
  ACHIEVEMENTEXPERIENCEPOINT = 100

  # 次レベル
  UNTILNEXTLEVEL = 1

  # ユーザのレベルアップとレベルダウン処理を行う
  def levelUpAndDown(task_id, action_day, action)

    # task_idから目標を取得
    goal = Task.getTaskGoal(task_id)

    # 実績日をTime型に変換
    action_day = Time.parse(action_day)

    # 曜日を取得
    action_day_of_week = getDayOfTheWeek(action_day)

    # 曜日毎に1週間の範囲を取得
    action_day_of_the_week = getWeekRange(action_day, action_day_of_week)
    from = action_day_of_the_week[0]
    to = action_day_of_the_week[1]

    # 1週間の実績を合計
    week_of_action = ActionRecord.weekOfActions(task_id, from, to).sum

    # レベル処理前の総経験値を取得
    before_total_experience_point = UserLevel.getTotalExperiencePoint(current_user.id)

    # レベル処理前のレベルを取得
    before_level = after_level = UserLevel.getUserLevel(current_user.id)

    # レベル処理前のレベルの必要経験値を取得
    before_level_required_experience_point = Level.getRequreidExperiecePoint(before_level)

    # 次レベルの必要経験値を取得
    next_level_required_experience_point = Level.getRequreidExperiecePoint(before_level + UNTILNEXTLEVEL)

    # レベル処理前のレベルの経験値テーブルにおける%を計算する
    before_experience_point_percent = ((before_total_experience_point - before_level_required_experience_point).to_f / (next_level_required_experience_point - before_level_required_experience_point).to_f * PERCENT).floor

    action_record = ActionRecord.getActionRecord(action_day, task_id, current_user.id)

    # 既にデータが存在しているかチェック
    if action_record.nil?
      # データが存在しない場合

      # 獲得経験値を計算
      point = culcurateExperiencePoint(action, goal)

      # 今回の追加分の前に目標を達成しているかチェック
      if (week_of_action < goal)
        #今回の追加分を含めた場合に目標を達成しているかチェック
        if ((week_of_action + action) >= goal)
          # 目標達成で経験値を追加
          point += ACHIEVEMENTEXPERIENCEPOINT
        end
      end

      # 今回獲得した経験値を足した総経験値を計算
      after_total_experience_point = before_total_experience_point + point

      # 総経験値が次レベルの必要経験値を上回ってる場合は処理に入る
      if (after_total_experience_point >= next_level_required_experience_point)

        # 総経験値が次レベルの必要経験値を下回るまでレベルアップする
        while after_total_experience_point >= next_level_required_experience_point
          # レベルアップ
          after_level += UNTILNEXTLEVEL
          # レベルアップ後の次レベルの必要経験値を取得
          next_level_required_experience_point = Level.getRequreidExperiecePoint(after_level + UNTILNEXTLEVEL)
        end

        # レベルアップ処理後のレベルを登録
        UserLevel.uploadUserLevel(current_user.id, after_level)
      end
    else
      # 一致するデータがある場合

      # 今回修正された実績と登録されている実績との差分を出す
      difference = action.to_f - action_record.action.to_f

      # 修正により実績が増加した場合
      if (difference > 0)
        # 差分と目標で経験値を算出
        point = culcurateExperiencePoint(difference, goal)

        # 今回の差分の前に目標に達しているかチェック
        if (week_of_action <= goal)
          # 目標に達していない場合、今回の追加分で目標に達したかチェック
          if ((week_of_action + difference) >= goal)
            # 今回の追加分で目標に達した場合は経験値を増加
            point += ACHIEVEMENTEXPERIENCEPOINT
          end
        end

        # 今回獲得した経験値を足した総経験値を計算
        after_total_experience_point = before_total_experience_point + point

        # 現在の総経験値が次のレベルの必要経験値を上回っているかチェック
        if (after_total_experience_point >= next_level_required_experience_point)
          # 上回っている場合、総経験値が次のレベルの必要経験値を下回るまでレベルアップ処理を繰り返す
          while after_total_experience_point >= next_level_required_experience_point
            # レベルアップ
            after_level += UNTILNEXTLEVEL
            # レベルアップ後の次レベルの必要経験値を取得
            next_level_required_experience_point = Level.getRequreidExperiecePoint(after_level + UNTILNEXTLEVEL)
          end

          # ユーザのレベルアップ処理後にレベルを登録
          UserLevel.uploadUserLevel(current_user.id, after_level)
        end
      else
        # 修正によりactionが減少した場合

        # 差分と目標から減少する経験値を計算
        point = culcurateExperiencePoint(difference, goal)

        # 今回の減少分で減少する前に目標を達しているかチェック
        if (week_of_action >= goal)
          # 目標を達してい場合、今回の減少分で割ったかチェック
          if ((week_of_action + difference) < goal)
            # 今回の減少分で割っている場合は経験値を減少
            point -= ACHIEVEMENTEXPERIENCEPOINT
          end
        end

        # 今回の減少分の経験値を引いて新しい総経験値を計算
        after_total_experience_point = before_total_experience_point + point

        # 現在のレベルの必要経験値を取得
        current_level_required_experience_point = Level.getRequreidExperiecePoint(after_level)

        # 今回の減少分を含めた総経験値が現在のレベルの必要経験値を割っていないかチェック
        if (after_total_experience_point < current_level_required_experience_point)
          # 必要経験値を割っている場合はレベルダウン後の必要経験値を割らなくなるまでレベルダウンを繰り返す
          while after_total_experience_point < current_level_required_experience_point
            # レベルダウン
            after_level -= UNTILNEXTLEVEL
            # レベルダウン後の次レベルの必要経験値を取得
            current_level_required_experience_point = Level.getRequreidExperiecePoint(after_level)
          end

          # レベルダウン処理後のレベルを登録
          UserLevel.uploadUserLevel(current_user.id, after_level)
        end
      end
    end

    # 総経験値を登録
    UserLevel.uploadUserTotalExperiencePoint(current_user.id, after_total_experience_point)

    # レベル処理後の現在レベルの必要経験値を計算
    after_level_required_experience_point = Level.getRequreidExperiecePoint(after_level)

    # レベル処理後の次レベルの必要経験値を計算
    after_experience_point_percent = ((after_total_experience_point - after_level_required_experience_point).to_f / (next_level_required_experience_point - after_level_required_experience_point).to_f * PERCENT).floor

    # フロントでのレベル処理に必要なデータを作成
    levelup_data = {}
    levelup_data.store(:before_level, before_level)
    levelup_data.store(:after_level, after_level)
    levelup_data.store(:before_experience_point_percent, before_experience_point_percent)
    levelup_data.store(:after_experience_point_percent, after_experience_point_percent)

    levelup_data
  end
end
