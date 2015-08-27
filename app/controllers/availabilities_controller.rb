class AvailabilitiesController < ApplicationController
  def new
    if Doctor.find(params[:doctor_id])
      @availability = Availability.new
      authorize @availability
    end
  end

  def create
    @doctor = Doctor.find(params[:doctor_id])
    @availability = @doctor.availabilities.new(availability_params)
    authorize @availability
    if @availability.save
      redirect_to @availability.doctor, notice: "Availability successfully created"
    else
      render :new
    end
  end

  def destroy
    @availability = Availability.find(params[:id])
    authorize @availability
    @availability.destroy
    redirect_to @availability.doctor, notice: "Availability successfully deleted"
  end

  private

    def availability_params
      params.require(:availability)
            .permit(:clinic_id, :day, :begin_time, :end_time)
    end

end
