class Api::UserLevelsController < ApplicationController
  def show
    @user_level = UserLevel.find_by(user_id: params[:user_id])
  end

  def create
    @user_level = UserLevel.new(user_levels_params)

    if @user_level.save
    else
      render json: @user_level.errors, status: :unprocessable_entity
    end
  end

  private

  def user_levels_params
    params.require(:user_level).permit(:level, :total_experience_point, :user_id)
  end
end
