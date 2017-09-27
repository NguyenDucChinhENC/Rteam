module Serializers
  module User
    class UsersSerializer < Serializers::SupportSerializer
      attrs :id, :email, :name, :avatar, :number_phone, :birthday
      attrs :address, :country, :id_number, :link_facebook, :workplace
    end
  end
end