# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
require File.expand_path("../config/environment", __dir__)

timezone = Time.zone.tzinfo.name
set :output, {error: "log/cron-error.log", standard: "log/cron.log"}
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#

# every :day, at: "07:00am", tz: timezone do
#   runner "AutoImportAndReservationEmptestWorker.perform_async"
# end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 1.minute do
  runner "HardWorker.perform_async"
end  

# Learn more: http://github.com/javan/whenever
