class MentorMeetingNotifications
  def self.send_notification(team_id, meeting_date)
    ActiveSupport::Notifications.instrument('mentor_meeting.created', team_id: team_id, meeting_date: meeting_date)
  end
end

ActiveSupport::Notifications.subscribe('mentor_meeting.created') do |name, start, finish, id, payload|
  puts "New meeting created for team #{payload[:team_id]} on #{payload[:meeting_date]}"
end
