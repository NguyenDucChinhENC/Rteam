module Serializers
  module Users
    class MiniUsersEventSerializer < Serializers::SupportSerializer
      attrs :id, :email, :name, :avatar, :number_phone, :birthday
      attrs :address, :country, :id_number, :link_facebook, :workplace
      attrs :member_event_id

      def member_event_id
      	member = MemberEvent.find_by(event_id: id_event, membereventtable_id: id)
      	member.id
      end
    end
  end
end