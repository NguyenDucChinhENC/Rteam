module Serializers
  module User
    class MemberWaitingAcceptSerializer < Serializers::SupportSerializer
      attrs :id, :email, :name, :avatar, :id_member_group
    end

    def id_member_group
      byebug
    end
  end
end
