class DoctorDecorator < Draper::Decorator
  delegate_all

  def first_availability_link(clinic)
    h.link_to l(doctor.first_availability_date(clinic), format: '%a, %d %b %Y') + ' (sprawdź)',
              h.doctor_path(object)
  end

  def next_week_link(date)
    date = Time.parse(date) + 7.days
    date = date.strftime '%d-%m-%Y'
    h.link_to 'Następny tydzień', h.doctor_url(object, when: date)
  end

  def previous_week_link(date)
    date = Time.parse(date) - 7.days
    date = date.strftime '%d-%m-%Y'
    h.link_to 'Poprzedni tydzień', h.doctor_url(object, when: date)
  end

end
