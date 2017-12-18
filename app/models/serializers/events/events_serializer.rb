include ActionView::Helpers::DateHelper

module Serializers
  module Events
    class EventsSerializer < Serializers::SupportSerializer
      attrs :id, :name, :eventtable_id, :eventtable_type
      attrs :quantity, :time, :registration_deadline, :photo
      attrs :location, :infor, :admin, :member, :created_at, :updated_at, :time_ago

      def admin
        if admin_event = AdminEvent.find_by_event_id_and_user_id(id, id_user)
          return true
        else
          return false
        end
      end

      def member
        if member_event = MemberEvent.find_by(event_id: id, user_id: id_user)
          return true
        else
          return false
        end
      end

      def time_ago
        time_ago_in_words(created_at)
      end

    end
  end
end
