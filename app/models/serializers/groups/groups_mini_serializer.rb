include ActionView::Helpers::DateHelper

module Serializers
  module Groups
    class GroupsMiniSerializer < Serializers::SupportSerializer
      attrs :id, :name, :description, :time_ago, :admin, :cover

      def admin
      	# @membered = MemberGroup.find_by_membergrouptable_id_and_id_group(id_user,id)
      	@membered = MemberGroup.find_by(membergrouptable_id: id_user, id_group: id)
        if (@membered)
      	 @membered.admin
        end
      end

      def time_ago
      	@membered = MemberGroup.find_by_membergrouptable_id_and_id_group(id_user,id)
        if (@membered)
          time_ago_in_words(@membered.created_at)
        end
      end
    end
  end
end