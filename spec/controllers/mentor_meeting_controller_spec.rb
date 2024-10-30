require 'rails_helper'

RSpec.describe MentorMeetingController, type: :controller do
  describe 'POST #add_date' do
    it 'creates a new meeting date and triggers a notification' do
      expect {
        post :add_date, params: { team_id: 1, meeting_date: '2024-11-01' }
      }.to change(MentorMeeting, :count).by(1)

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq('success')
    end
  end

  describe 'PATCH #edit_date' do
    it 'updates the meeting date' do
      mentor_meeting = MentorMeeting.create!(team_id: 1, meeting_date: '2024-11-01')
      patch :edit_date, params: { team_id: 1, old_date: '2024-11-01', new_date: '2024-11-02' }
      
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq('success')
      expect(mentor_meeting.reload.meeting_date).to eq('2024-11-02')
    end
  end

  describe 'DELETE #delete_date' do
    it 'deletes the meeting date' do
      mentor_meeting = MentorMeeting.create!(team_id: 1, meeting_date: '2024-11-01')
      expect {
        delete :delete_date, params: { team_id: 1, meeting_date: '2024-11-01' }
      }.to change(MentorMeeting, :count).by(-1)
      
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq('success')
    end
  end
end
