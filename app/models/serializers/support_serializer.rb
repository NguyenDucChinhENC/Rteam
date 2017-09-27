module Serializers
  class SupportSerializer < Serializers::BaseSerializer
    def object
      @object ||= nil
    end
  end
end