# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'

unless Contact.count > 0
  uri = URI 'https://gist.githubusercontent.com/mikeolivieri/9222832/raw/ad32c0ad6630d49374b29f23ddf7d1fa2b55f45a/articulate-data'
  contacts = JSON.load Net::HTTP.get(uri)
  contacts.each do |contact|
    contact['birthday'] = Date.strptime contact['birthday'], '%m/%d/%Y'
    contact.merge! 'address_attributes' => contact.delete('address')
    Contact.create contact.slice(*%w(name sex birthday phone email address_attributes))
  end
end
