Address = require 'models/address'

class Contact extends Backbone.NestedAttributesModel
  urlRoot: '/contacts'

  relations: [
    {
      type: 'one'
      key:  'address'
      relatedModel: -> Address
    }
  ]

  choose: ->
    @collection.each (contact) -> contact.set active: false
    @set active: true

module.exports = Contact
