Card = require 'views/card'
CompositeView = require 'lib/composite_view'
router = require 'router'

class ContactsView extends CompositeView
  template: require 'templates/contacts'

  initialize: (options) ->
    super options
    @collection = require 'collections/contacts'
    @listenTo @collection, 'sort', @_renderCollection
    @collection.fetch()

  events:
    'click #new': -> router.navigate '#/contacts/new', trigger: true

  render: ->
    @$el.html @template()
    @_renderCollection()
    this

  _renderCollection: ->
    @_removeChildren()
    @collection.each (model) =>
      @$el.append @renderChild(new Card model: model).el

module.exports = ContactsView
