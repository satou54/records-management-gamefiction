class UserLevelsController < ApplicationController

  # ユーザのレベルアップとレベルダウン処理を行う
  def levelUpAndDown(task_id, action_day, action)
    # task_idからtaskのgoalを取得
    goal = getGoal(task_id)

    # 追加した日を取得してTime型に変換
    action_day = Time.parse(action_day)

    # 曜日毎に1週間の範囲を取得
    # 複数の戻り値を取得する方法は後で調べる
    from...to = getDayOfTheWeek

    # 1週間の実績を配列で取得
    week_of_actions = weekOfActions(task_id, from, to)

    # 1週間の実績の合計
    week_of_action = week_of_actions.sum

    # ユーザの総経験値を取得
    total_experience_point = getTotalExperiencePoint(current_user.id)

    # ユーザのレベルを取得
    getUserLevel(current_user.id)

    # ユーザの次レベルの経験値を取得
    next_level_required_experience_point = getRequreidExperiecePoint(level + 1)

    # 既にデータが存在しているかチェック
    if (checkActionRecord?(action_day, task_id, current_user.id).nil?)
      # データが存在しない場合

      # actionとgoalを比較して経験値を算出
      point = culcurateExperiencePoint(action, goal)

      # 今回の追加分の前に目標を達成しているかチェック
      if ((week_of_action - action) < goal)
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
          next_level_required_experience_point = getRequreidExperiecePoint(level + 1)
        end

        # ユーザのレベルアップ後のレベルをuser_levelsに登録
        puts "level_after"
        uploadUserLevel(current_user.id, level)
        end
    else
      # 一致するデータがある場合

      # 今回修正されたactionとDBに登録されているactionとの差分を出す
      difference = action.to_f - @action_record.action.to_f

      # 差分から今回の修正で増加か減少かで条件分岐

      # 修正によりactionが増加した場合
      if (difference > 0)
        # 差分とgoalで経験値を算出
        point = (difference.to_f / goal.to_f * 100).floor
        # 今回の差分の前に目標に達しているかチェック
        if ((week_of_action - action) < goal)
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
            next_level_required_experience_point = getRequreidExperiecePoint(level + 1)
          end
          
          # ユーザのレベルアップ処理後にユーザのレベルをuser_levelsテーブルに保存
          uploadUserLevel(current_user.id, level)
        end

        # 先ほど計算した今回の追加分を含めた総経験値をuser_levelsテーブルに登録
        uploadUserTotalExperiencePoint(current_user.id, total_experience_point)
          
        # 次のレベルアップまでに必要な経験値を計算する
        next_level_required_experience_point = getRequreidExperiecePoint(level+1)
        until_levelup = next_level_required_experience_point - total_experience_point
      else
        # 修正によりactionが減少した場合
        
        # 差分とgoalから減少分の経験値を算出
        point = (difference.to_f / goal.to_f * 100).floor
        # 今回の減少分で減少する前に目標を達しているかチェック
        if ((week_of_action - action) > goal)
          # 目標を達してい場合、今回の減少分で割ったかチェック
          if (week_of_action < goal)
            # 今回の減少分で割っている場合、経験値を-100
            point -= 100
          end
        end
        # 今回の減少分の経験値を引いて新しい総経験値を計算
        total_experience_point += 100

        # 現在のレベルの必要経験値を取得
        current_level_required_experience_point = getRequreidExperiecePoint(level)

        # 今回の減少分を含めた総経験値が現在のレベルの必要経験値を割っていないかチェック
        if (total_experience_point < current_level_required_experience_point)
          # 必要経験値を割っている場合はレベルダウン後の必要経験値を割らなくなるまでレベルダウンを繰り返す
          while total_experience_point >=  current_level_required_experience_point
            puts "レベルダウン"
            level -= 1
            current_level_required_experience_point = getRequreidExperiecePoint(level)
          end
          # 処理後のレベルをuser_levelsテーブルに保存
          uploadUserLevel(current_user.id, level)
        end
      end

      # 総経験値をuser_levelsテーブルに登録
      uploadUserTotalExperiencePoint(current_user.id, total_experience_point)

      # 次のレベルアップに必要な経験値を計算する
      until_levelup = getNextLevelRequreidExperiencePoint(level)

      # 配列を作って情報を返す
      levelup_data = {}
      levelup_data.store(:level, level)
      levelup_data.store(:total_experience_point, total_experience_point)
      levelup_data.store(:next_level_required_experience_point, next_level_required_experience_point)
      levelup_data.store(:until_levelup, until_levelup)
      puts "levelup_data"
      puts levelup_data

      levelup_data
    end
  end
end
