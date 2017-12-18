include ActionView::Helpers::DateHelper

module Serializers
  module Events
    class EventsShowSerializer < Serializers::SupportSerializer
      attrs :id, :name, :eventtable_id, :eventtable_type
      attrs :quantity, :time, :registration_deadline, :owner, :photo
      attrs :location, :infor, :admin, :member, :created_at, :time_ago
      attrs :member_joined, :list_admin

      def admin
        if admin_event = AdminEvent.find_by_event_id_and_user_id(id, id_user)
          return true
        else
          return false
        end
      end

      def member
        if member_event = MemberEvent.find_by(event_id: id, membereventtable_id: id_user)
          return member_event.id
        else
          return false
        end
      end

      def list_admin
        @event = Event.find_by(id: id);
        tmp =[];
        @event.admin_events.each do |a|
          user = User.find_by(id: a.user_id)
          tmp.push Serializers::Users::UsersSerializer.new(object: user, event_id: @event.id).serializer
        end
        tmp
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

      def member_joined
        @event = Event.find_by(id: id);
        tmp = [];
        @event.member_events.each do |m|
          user = User.find_by(id: m.membereventtable_id)
          tmp.push Serializers::Users::MiniUsersEventSerializer.new(object: user, event_id: @event.id).serializer
        end
        tmp
      end
    end
  end
end
