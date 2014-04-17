# == Schema Information
#
# Table name: addresses
#
#  id         :string(36)       not null
#  street     :string(255)
#  city       :string(255)
#  state      :string(2)
#  postcode   :string(255)
#  contact_id :string(36)       not null
#  created_at :datetime
#  updated_at :datetime
#

class Address < ActiveRecord::Base
  include Uuidentified
  belongs_to :contact

  validates :state, format: { with: /\A[A-Z]{2}\Z/, message: "Must be capitalized two-letter abbreviation" }
end
