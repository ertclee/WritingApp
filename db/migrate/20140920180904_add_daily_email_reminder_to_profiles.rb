class AddDailyEmailReminderToProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :daily_email_reminder, :boolean
  end
end
