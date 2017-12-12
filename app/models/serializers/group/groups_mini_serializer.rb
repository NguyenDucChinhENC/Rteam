include ActionView::Helpers::DateHelper

module Serializers
  module Group
    class GroupsMiniSerializer < Serializers::SupportSerializer
      attrs :id, :name, :description, :time_ago, :admin

      def admin
      	# @membered = MemberGroup.find_by_membergrouptable_id_and_id_group(id_user,id)
      	@membered = MemberGroup.find_by(membergrouptable_id: id_user, id_group: id)
      	@membered.admin
      end

      def time_ago
      	@membered = MemberGroup.find_by_membergrouptable_id_and_id_group(id_user,id)
        time_ago_in_words(@membered.created_at)
      end
    end
  end
end