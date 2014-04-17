class Contacts extends Backbone.Collection
  url: '/contacts'
  model: require 'models/contact'

module.exports = new Contacts()
