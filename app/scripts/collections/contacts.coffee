class Contacts extends Backbone.Collection
  url: '/contacts'
  model: require 'models/contact'
  comparator: 'name'

  choose: (contact) ->
    @invoke 'choose', contact

module.exports = new Contacts()
