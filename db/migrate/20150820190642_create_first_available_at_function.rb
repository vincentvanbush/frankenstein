class CreateFirstAvailableAtFunction < ActiveRecord::Migration
  def up
    execute <<-SQL
      create or replace function first_availability_date(integer, integer) returns timestamptz as '
        with days as (
                select generate_series as day, extract(dow from generate_series)
                from generate_series(date_trunc(''day'', now()), date_trunc(''day'', now()) + interval ''1 month'', ''1 day''::interval)
                where extract(dow from generate_series) in (select day from availabilities where doctor_id = $1 and clinic_id = $2)
            ), avsums as (
                select day, sum(end_time::interval - begin_time::interval)
                from availabilities
                where doctor_id = $1 and clinic_id = $2
                group by day
            ), remaining_appointments_today as (
                select sum(s) sum from (
                  (
                    select sum(ends_at - now()) s
                    from appointments
                    where doctor_id = $1 and clinic_id = $2
                    and begins_at::date = now()::date and begins_at < now() and ends_at > now()
                  )
                  union all
                  (
                    select sum(ends_at - begins_at) s
                    from appointments
                    where doctor_id = $1 and clinic_id = $2
                    and begins_at::date = now()::date and begins_at > now()
                  )
                  union all (select interval ''0'')
                ) as tmp
            ), sums as (
                select begins_at::date date_trunc,
                    case when begins_at::date = now()::date then (select sum from remaining_appointments_today)
                    else sum(ends_at - begins_at)
                end
                from appointments
                where doctor_id = $1 and clinic_id = $2
                group by begins_at::date
            ), elapsed_availabilities_today as (
                select sum(s) sum from (
                  (select sum(now()::time - begin_time::time) s
                   from availabilities
                   where doctor_id = $1 and clinic_id = $2
                   and day = extract(dow from now()) and begin_time::time < now()::time and end_time::time > now()::time)
                union all
                  (select sum(end_time::time - begin_time::time) s
                   from availabilities
                   where doctor_id = $1 and clinic_id = $2
                   and day = extract(dow from now()) and end_time::time < now()::time)
                ) as tmp
            ), dayavs as (
                select days.day date,
                    case when days.day = now()::date then sum - (select sum from elapsed_availabilities_today) - (select sum from remaining_appointments_today)
                         else sum
                    end
                from days join avsums on days.date_part = avsums.day
            )
        select min(date) first_availability_date from dayavs
        where sum > coalesce((select sum from sums where date = sums.date_trunc), ''00:00:00'');'
      language sql;

    SQL
  end

  def down
    execute <<-SQL
      drop function first_availability_date;
    SQL
  end

end
