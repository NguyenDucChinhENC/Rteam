module Serializers
  module Users
    class MiniUsersSerializer < Serializers::SupportSerializer
      attrs :id, :email, :name, :avatar
    end
  end
end