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
      flash.now.notice = "更新した"
    else
      @tasks = Task.all
      flash.now.alert = "失敗した"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:name)
  end
end
