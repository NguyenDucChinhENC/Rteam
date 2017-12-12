include ActionView::Helpers::DateHelper

module Serializers
  module Event
    class EventsSerializer < Serializers::SupportSerializer
      attrs :id, :name, :eventtable_id, :eventtable_type
      attrs :quantity, :time, :registration_deadline
      attrs :location, :infor, :admin, :created_at, :updated_at, :time_ago

      def admin
        if admin_event = AdminEvent.find_by_event_id_and_user_id(id, id_user)
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
