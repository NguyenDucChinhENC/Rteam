module Serializers
  class SupportSerializer < Serializers::BaseSerializer
    def object
      @object ||= nil
    end

    def id_user
      @id_user ||= nil
    end

    def event_id
      @event_id ||=nil
    end
  end
end