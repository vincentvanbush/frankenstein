class AppointmentsController < ApplicationController
  def index
    authorize Appointment
    if current_user.is_a? Admin
      @appointments = Appointment.all
    else
      @appointments = current_user.appointments
    end
  end

  def create
    @appointment = Appointment.new(appointment_params)
    authorize @appointment
    if @appointment.save
      redirect_to @appointment, notice: "Appointment successfully created"
    else
      render :new
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
    authorize @appointment
  end

  def confirm
    @appointment = Appointment.find(params[:id])
    authorize @appointment
    if @appointment.update(confirmed_at: Time.current)
      redirect_to @appointment, notice: 'Appointment has been confirmed'
    else
      render :show, flash: { error: 'Appointment could not be confirmed' }
    end
  end

  def cancel
    @appointment = Appointment.find(params[:id])
    authorize @appointment
    if @appointment.update(cancelled_at: Time.current)
      redirect_to @appointment, notice: 'Appointment has been cancelled'
    else
      render :show, flash: { error: 'Appointment could not be cancelled' }
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    authorize @appointment
    if @appointment.destroy
      redirect_to appointments_url, notice: 'Appointment has been deleted'
    else
      render :show, flash: { error: 'Appointment could not be deleted' }
    end
  end

  private

  def appointment_params
    params.require(:appointment)
          .permit(:patient_id, :doctor_id, :clinic_id, :begins_at, :ends_at,
                  :confirmed_at, :cancelled_at, :availability_id)
  end

end
