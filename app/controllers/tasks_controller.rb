class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @user = User.find(current_user.id)
    @tasks = @user.tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # play task
  def play
    current_button_text = params[:currentButtonText]
    id = params[:id]
    @task = Task.find(id)

    if current_button_text=="Play"
      # if i start another task where is another one running, should be paused
      @started_task = Task.where.not(id: id).find_by(status: Task.statuses[:started])
      if @started_task.present? && @started_task.id.present?
        @started_task.status = Task.statuses[:paused]
        @started_task.save
      end
      # ----------------------------------------------------------------------
      @task.status = Task.statuses[:started]
      @task.startTime = Time.now
    elsif current_button_text=="Pause"
      @task.endTime = Time.now
      @task.status = Task.statuses[:paused]
      @task.seconds += (@task.endTime - @task.startTime).to_i
    end

    @task.save
  end

  def stop
    @task = Task.find(params[:id])
    @task.status = Task.statuses[:stopped]
    @task.endTime = Time.now
    @task.seconds += (@task.endTime - @task.startTime)
    @task.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :startTime, :endTime, :status, :project_id)
    end
end
