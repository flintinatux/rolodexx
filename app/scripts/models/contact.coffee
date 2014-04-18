Address = require 'models/address'

class Contact extends Backbone.UndoableModel
  urlRoot: '/contacts'

  relations: [
    {
      type: 'one'
      key:  'address'
      relatedModel: -> Address
    }
  ]

  validation:
    name:
      required: true
      msg: "Can't be blank"
    email:
      required: false
      pattern: 'email'

  choose: ->
    @collection?.each (contact) -> contact.set active: false
    @set active: true

module.exports = Contact
