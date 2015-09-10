class AppointmentsController < ApplicationController
  def index
    authorize Appointment
    if current_user.is_a? Admin
      @appointments = Appointment.all.decorate
    else
      @appointments = current_user.appointments.decorate
    end
  end

  def create
    @appointment = Appointment.new(appointment_params).decorate
    authorize @appointment
    if @appointment.save
      redirect_to appointments_path, notice: "Appointment successfully created"
    else
      render :new, flash: { error: 'Appointment could not be created '}
    end
  end

  def new
    @appointment = Appointment.new.decorate
    authorize @appointment
    @appointment.availability = Availability.find(params[:availability_id])
    @appointment.doctor = @appointment.availability.doctor
    @appointment.clinic = @appointment.availability.clinic
    @appointment.patient = current_user
    @appointment.begins_at = Time.zone.parse(params[:begins_at])
    @appointment.ends_at = @appointment.begins_at + 30.minutes
  end

  def confirm
    @appointment = Appointment.find(params[:id])
    authorize @appointment
    if @appointment.update(confirmed_at: Time.current)
      flash[:notice] = 'Appointment has been confirmed'
      redirect_to action: :index
    else
      flash[:error] = 'Appointment could not be confirmed'
      redirect_to action: :index
    end
  end

  def cancel
    @appointment = Appointment.find(params[:id])
    authorize @appointment
    if @appointment.update(cancelled_at: Time.current)
      flash[:notice] = 'Appointment has been cancelled'
      redirect_to action: :index
    else
      flash[:error] = 'Appointment could not be cancelled'
      redirect_to action: :index
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    authorize @appointment
    if @appointment.destroy
      flash[:notice] = 'Appointment has been deleted'
      redirect_to action: :index
    else
      flash[:error] =  'Appointment could not be deleted'
      redirect_to action: :index
    end
  end

  private

  def appointment_params
    params.require(:appointment)
          .permit(:patient_id, :doctor_id, :clinic_id, :begins_at, :ends_at,
                  :confirmed_at, :cancelled_at, :availability_id)
  end

end
