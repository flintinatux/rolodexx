# == Schema Information
#
# Table name: contacts
#
#  id         :string(36)       not null, primary key
#  name       :string(255)
#  sex        :string(255)
#  birthday   :date
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Contact < ActiveRecord::Base
  include Uuidentified
  has_one :address

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true
  validates :sex,   inclusion: { in: %w(male female) }
  validates :email, format: { with: EMAIL_REGEX }

  validates_each :birthday, allow_nil: true do |record, attribute, value|
    record.errors.add attribute, "Can't be in the future" if value > Date.today
  end

  def age
    ((Date.today - birthday).to_f / 365.25).to_i
  end
end
