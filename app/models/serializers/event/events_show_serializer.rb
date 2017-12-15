include ActionView::Helpers::DateHelper

module Serializers
  module Event
    class EventsShowSerializer < Serializers::SupportSerializer
      attrs :id, :name, :eventtable_id, :eventtable_type
      attrs :quantity, :time, :registration_deadline, :owner, :photo
      attrs :location, :infor, :admin, :created_at, :time_ago

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

      def owner
        if eventtable_type = "Group"
          @group = Group::find_by id: eventtable_id
          return { :id => @group.id,  :name =>@group.name} 
        end
      end
    end
  end
end
