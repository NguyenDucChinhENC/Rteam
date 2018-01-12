class Reply < ApplicationRecord
	belongs_to :comment, foreign_key: 'father_id'
end
