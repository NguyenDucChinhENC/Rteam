include ActionView::Helpers::DateHelper

module Serializers
  module Events
    class EventsShowSerializer < Serializers::SupportSerializer
      attrs :id, :name, :eventtable_id, :eventtable_type
      attrs :quantity, :time, :registration_deadline, :owner, :photo
      attrs :location, :infor, :admin, :member, :created_at, :time_ago
      attrs :member_joined, :list_admin, :comments

      def admin
        admin_event = AdminEvent.find_by_event_id_and_user_id(id, id_user)? true : false
      end

      def member
        member_event = MemberEvent.
          find_by(event_id: id, membereventtable_id: id_user)
        member_event ? member_event.id : false
      end

      def list_admin
        tmp =[];
        object.admin_events.each do |a|
          tmp.push Serializers::Users::UsersSerializer.
            new(object: a.user, event_id: object.id).serializer
        end
        tmp
      end

      def owner
        if eventtable_type = "Group"
          return { :id => object.eventtable.id,  :name => object.eventtable.name} 
        end
      end

      def member_joined
        @event = Event.find_by(id: id)
        tmp = []
        object.member_events.each do |m|
           tmp.push Serializers::Users::MiniUsersEventSerializer.
           new(object: m.membereventtable, id_event: object.id).serializer
          end
          tmp
      end

      def comments
        Serializers::Comments::CommentsSerializer.new(object: object.comments).serializer
      end

      def time_ago
        time_ago_in_words(created_at)
      end
    end
  end
end
