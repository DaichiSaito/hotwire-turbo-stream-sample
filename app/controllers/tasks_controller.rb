class TasksController < ApplicationController

  def index
    @tasks = Task.all
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      # 第一引数はturbo_stream_fromの引数と同じにする
      # targetはtaskリストの親要素のid
      Turbo::StreamsChannel.broadcast_append_to :home, target: :tasks, partial: "tasks/task", locals: { task: @task }
      flash.now.notice = "作成した"
    else
      @tasks = Task.all
      flash.now.alert = "失敗した"
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash.now.notice = "削除した"
    Turbo::StreamsChannel.broadcast_remove_to :home, target: @task
  end

  def edit
    @task = Task.find(params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      Turbo::StreamsChannel.broadcast_replace_to :home, target: @task, partial: "tasks/task", locals: { task: @task }
      flash.now.notice = "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :completed)
  end
end
