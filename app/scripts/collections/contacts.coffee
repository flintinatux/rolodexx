class Contacts extends Backbone.Collection
  url: '/contacts'
  model: require 'models/contact'
  comparator: 'name'

module.exports = new Contacts()
