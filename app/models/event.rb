class Event < ApplicationRecord
  ATTRIBUTES_PARAMS = [:name, :quantity, :time, :location, :registration_deadline, :infor, :status].freeze
  belongs_to :eventtable, polymorphic: true
  has_many :admin_events
  has_many :member_events

  validates :name, presence: true
  validates :quantity, presence: true
  validates :time, presence: true
  validates :registration_deadline, presence: true
  validates :infor, presence: true
  validates :check_deadline, presence: true

  private

  def check_deadline
    if registration_deadline.present? && registration_deadline > Date.today && 
      time.present? && registration_deadline < time
      return true
    else 
      errors.add(:base, "Errors on Date Time")
      return false
    end
  end
end
