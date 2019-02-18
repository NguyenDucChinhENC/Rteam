require "elasticsearch/model"

class Group < ApplicationRecord

	# include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  ATTRIBUTES_PARAMS = [:name, :description, :public_status, :enable_search, :cover].freeze

  mount_base64_uploader :cover, CoverUploader

  has_many :member_group
  has_many :events, as: :eventtable

  validates :name, presence: true

  # settings index: {number_of_shards: 1} do
  #   mappings dynamic: "false" do
  #     indexes :name, analyzer: "english"
  #   end
  # end

#   class << self
#     def search query
#       __elasticsearch__.search(
#         {
#           query: {
#             multi_match: {
#               query: query,
#               fields: ["name^5"]
#             }
#           }
#         }
#       )
#     end
#   end
# end

# Group.__elasticsearch__.client.indices.delete index: Group.index_name rescue nil
# Group.__elasticsearch__.client.indices.create \
#   index: Group.index_name,
#   body: { settings: Group.settings.to_hash, mappings: Group.mappings.to_hash }
# Group.import
