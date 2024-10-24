class MentorMeetingController < ApplicationController
  include MentorMeetingsHelper

  # Method to get meeting dates for a particular assignment
  def get_dates
    @mentor_meetings = MentorMeeting.all
    render json: @mentor_meetings
  end

  # Method to add meetings dates to the mentor_meetings table.
  def add_date
    team_id = params[:team_id]
    meeting_date = params[:meeting_date]
    @mentor_meeting = MentorMeeting.create(team_id: team_id, meeting_date: meeting_date)
    
    if @mentor_meeting.save
      MentorMeetingNotifications.send_notification(team_id, meeting_date)
      render json: { status: 'success', message: "Meeting date added" }
    else
      render json: { status: 'error', message: "Unable to add meeting date" }
    end
  end
  
  

  def edit_date
    team_id = params[:team_id]
    old_meeting_date = params[:old_date]
    new_meeting_date = params[:new_date]
  
    @meeting = MentorMeeting.where(team_id: team_id.to_i, meeting_date: old_meeting_date).first
    if @meeting
      @meeting.meeting_date = new_meeting_date
      if @meeting.save
        # Trigger notification after editing
        ActiveSupport::Notifications.instrument('mentor_meeting.updated', team_id: team_id, old_meeting_date: old_meeting_date, new_meeting_date: new_meeting_date)
        render json: { status: 'success', message: 'Meeting updated successfully' }
      else
        render json: { status: 'error', message: 'Failed to update meeting' }
      end
    else
      render json: { status: 'error', message: 'Meeting not found' }
    end
  end
  

  def delete_date
    team_id = params[:team_id]
    meeting_date = params[:meeting_date]
    @meeting = MentorMeeting.where(team_id: team_id.to_i, meeting_date: meeting_date).first
  
    if @meeting
      @meeting.destroy
      # Trigger notification after deletion
      ActiveSupport::Notifications.instrument('mentor_meeting.deleted', team_id: team_id, meeting_date: meeting_date)
      render json: { status: 'success', message: 'Meeting deleted successfully' }
    else
      render json: { status: 'error', message: 'Meeting not found' }
    end
  end
  

end
