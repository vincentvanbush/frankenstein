#= require moment
#= require underscore
#= require easycal

jQuery ->
  format = 'DD-MM-YYYY'

  window.sliceEvent = (event, duration) ->
    ret = []
    time_start = moment(event.start, 'DD-MM-YYYY HH:mm')
    time_end = moment(event.end, 'DD-MM-YYYY HH:mm')

    t = moment(time_start)
    t30 = moment(t).add(duration, 'minutes')
    while (t30.isSame time_end) || (t30.isBefore time_end)
      ev =
        id: JSON.stringify
          availability_id:  event.id
          time:             t.format('DD-MM-YYYY HH:mm')
        title:           event.title
        clinic_id:       event.clinic_id
        start:           t.format('DD-MM-YYYY HH:mm')
        end:             t30.format('DD-MM-YYYY HH:mm')
        backgroundColor: '#00BB22'
        textColor:       '#FFF'
      ret.push ev
      t = moment(t30)
      t30 = moment(t).add(30, 'minutes')
    ret

  window.prepareEvents = (forDate) ->
    startOfWeek = moment(forDate, format).startOf('isoWeek')

    gon.availabilities = gon.availabilities.map (a) ->
      a.start = startOfWeek.day(a.day).format('DD-MM-YYYY ') + a.begin_time
      a.end = startOfWeek.day(a.day).format('DD-MM-YYYY ') + a.end_time
      a
    gon.availabilities = gon.availabilities.filter (e) ->
      moment(e.start, 'DD-MM-YYYY HH:mm').isAfter moment()

    events = []
    gon.availabilities.map (a) ->
      sliced = sliceEvent(a, 30)
      events = events.concat sliced

    events.filter (event) ->
      clinicAppointments = gon.appointments.filter (a) ->
        true if a.clinic_id == event.clinic_id
      return true unless clinicAppointments.length > 0
      overlappingAppointments = clinicAppointments.filter (a) ->
        appointmentStartMoment = moment(a.begins_at)
        appointmentEndMoment = moment(a.ends_at)
        eventStartMoment = moment(event.start, 'DD-MM-YYYY HH:mm')
        eventEndMoment = moment(event.end, 'DD-MM-YYYY HH:mm')
        true if (appointmentStartMoment.isBefore(eventEndMoment) &&
                 appointmentEndMoment.isAfter(eventStartMoment))
      return true if overlappingAppointments.length == 0

  showCalendar = (forDate) ->
    startOfWeek = moment(forDate, format).startOf('isoWeek')
    events = prepareEvents(forDate)

    $('.mycal').easycal
      startDate:        startOfWeek
      timeFormat:       'HH:mm'
      columnDateFormat: 'dddd, DD MMM'
      minTime:          '09:00:00'
      maxTime:          '19:00:00'
      slotDuration:     30
      timeGranularity:  15

      dayClick: (el, startTime) ->
        console.log 'Slot selected: ' + startTime
      eventClick: (eventId) ->
        console.log 'Event was clicked with id: ' + eventId

      events:           events # gon.availabilities
      overlapColor:     '#FF0',
      overlapTextColor: '#000',
      overlapTitle:     'Multiple'

  showCalendar $('#when').val()
