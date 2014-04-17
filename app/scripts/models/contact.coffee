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

module.exports = Contact
