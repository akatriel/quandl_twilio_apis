desc "This task is called by the Heroku scheduler add-on"
task :update_stocks => :environment do
  puts "Updating stocks..."
  Stock.update
  puts "done."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end
