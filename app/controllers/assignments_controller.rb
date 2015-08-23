class AssignmentsController < ApplicationController
  def new
    if Doctor.find(params[:doctor_id])
      @assignment = Assignment.new
      binding.pry
      authorize @assignment
    end
  end

  def create
    @assignment = Assignment.new(assignment_params)
    authorize @assignment
    if @assignment.save
      redirect_to @assignment.doctor, notice: "Assignment successfully created"
    else
      render :new
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    authorize @assignment
    @assignment.destroy
    redirect_to @assignment.doctor, notice: "Assignment successfully deleted"
  end

  private

    def assignment_params
      params.permit(:doctor_id, :clinic_id)
    end

end
