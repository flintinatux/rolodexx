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

  initialize: (attributes, options) ->
    super attributes, options
    @channel = Backbone.Radio.channel _.result(this,'url')
    @listenTo @channel, 'updated', (attributes) => @set attributes

  choose: (contact) ->
    @set active: (contact == this)

module.exports = Contact
