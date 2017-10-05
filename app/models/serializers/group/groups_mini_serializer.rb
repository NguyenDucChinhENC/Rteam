module Serializers
  module Group
    class GroupsMiniSerializer < Serializers::SupportSerializer
      attrs :id, :name, :description

      def admin
      	@membered = MemberGroup.find_by_membergrouptable_id_and_id_group(args[:user], group.id)
      	@membered.admin
      end
    end
  end
end