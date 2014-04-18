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
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  before_validation :process_email

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  default_scope { order 'name asc' }

  validates :name,  presence: true
  validates :sex,   inclusion: { in: %w(male female) }, allow_nil: true
  validates :email, format: { with: EMAIL_REGEX }, allow_blank: true

  validates_each :birthday, allow_nil: true do |record, attribute, value|
    record.errors.add attribute, "Can't be in the future" if value > Date.today
  end

  def age
    ((Date.today - birthday).to_f / 365.25).to_i if birthday.present?
  end

  def gravatar_hash
    Digest::MD5.new.hexdigest email if email.present?
  end

  def self.attribute_names
    super + [:address_attributes]
  end

  private

    def process_email
      if email
        email.gsub! /\s/, ''
        email.downcase!
      end
    end
end
