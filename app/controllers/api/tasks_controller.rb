class Api::TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render :index, status: :created
    else
      render json: { errors: @task.errors.keys.map { |key| [key, @task.errors.full_messages_for(key)] }.to_h, render: "index.json.jbuilder" }, status: :unprocessable_entity
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
      render json: { errors: @task.errors.keys.map { |key| [key, @task.errors.full_messages_for(key)] }.to_h, render: "show.json.jbuilder" }, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      render :index, status: :ok
    else
      render json: { errors: @task.errors.keys.map { |key| [key, @task.errors.full_messages_for(key)] }.to_h, render: "index.json.jbuilder" }, status: :unprocessable_entity
    end
  end

  private

    def task_params
      params.fetch(:task, {}).permit(:task, :goal, :unit, :user_id)
    end
end
