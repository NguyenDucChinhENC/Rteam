class MemberGroup < ApplicationRecord
  belongs_to :membergrouptable, polymorphic: true
  belongs_to :group, foreign_key: 'id_group'
  ATTRIBUTES_PARAMS = [:id_group, :admin, :status, :accept].freeze

  class << self
  	def waiting id_group
  		tmp = where id_group: id_group if id_group.present?
  		tmp.where accept: false
  	end

  	def membered id_group
  		tmp = where id_group: id_group if id_group.present?
  		tmp.where accept: true
  	end
  end
end
