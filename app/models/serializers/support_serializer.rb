module Serializers
  class SupportSerializer < Serializers::BaseSerializer
    def object
      @object ||= nil
    end

    def id_user
      @id_user ||= nil
    end

    def id_event
      @id_event ||=nil
    end
  end
end