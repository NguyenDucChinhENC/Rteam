module Serializers
  module Group
    class GroupsMiniSerializer < Serializers::SupportSerializer
      attrs :id, :name, :description
    end
  end
end