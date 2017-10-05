module Serializers
  module User
    class MiniUsersSerializer < Serializers::SupportSerializer
      attrs :id, :email, :name, :avatar
    end
  end
end