class DoctorsController < ApplicationController

  def show
    @doctor = Doctor.find(params[:id]).decorate
    @when = extract_when
    gon.appointments = extract_appointments
    gon.availabilities = extract_availabilities
  end

  private

    def extract_when
      date = Time.parse(params['when'])
      date = date.strftime '%d-%m-%Y'
      date
    rescue ArgumentError, TypeError
      Time.current.strftime('%d-%m-%Y')
    end

    def extract_appointments
      appointments = @doctor.appointments.where("begins_at > ? and ends_at < ?",
                                                begin_of_week, end_of_week)
      if params[:clinic_id].present?
        appointments = appointments.where(clinic_id: params[:clinic_id])
      end
      appointments = appointments.select { |a| !a.cancelled? && !a.expired? }
      appointments.map { |a| { begins_at: a.begins_at, ends_at: a.ends_at,
                               clinic: a.clinic.name, clinic_id: a.clinic.id } }
    end

    def extract_availabilities
      availabilities = @doctor.availabilities
      if params[:clinic_id].present?
        availabilities = availabilities.where(clinic_id:  params[:clinic_id])
      end
      availabilities.map { |a| a.attributes.merge({ title: a.clinic.name,
                                                    clinic_id: a.clinic.id }) }
    end

    def begin_of_week
      Time.parse(extract_when).at_beginning_of_week
    end

    def end_of_week
      Time.parse(extract_when).at_end_of_week
    end

end
