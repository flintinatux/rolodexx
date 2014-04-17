module Uuidentified
  extend ActiveSupport::Concern

  included do
    self.primary_key = 'id'
    before_create { self.id = SecureRandom.uuid }
  end
end
