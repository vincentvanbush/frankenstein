class AssignmentsController < ApplicationController
  def index
    @assignments = Assignment.all
    authorize Assignment
  end

  def create
    @assignment = Assignment.new(assignment_params)
    authorize @assignment
    if @assignment.save
      redirect_to assignments_path, notice: "Assignment successfully created"
    else
      redirect_to assignments_path, flash: { error: "Assignment could not be created" }
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    authorize @assignment
    @assignment.destroy
    redirect_to assignments_path, notice: "Assignment successfully deleted"
  end

  private

    def assignment_params
      params.require(:assignment).permit(:doctor_id, :clinic_id)
    end

end
