class Api::TasksController < ApplicationController
  def index
    @tasks = Task.all
    #ログインエラー解決後に変更
    #@tasks = current_user.taks
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render :index, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      render :show, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      render :index, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.fetch(:task, {}).permit(:task, :goal, :user_id)
  end
end
