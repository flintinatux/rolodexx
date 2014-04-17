CompositeView = require 'lib/composite_view'
ContactsView  = require 'views/contacts'

class Main extends CompositeView
  template: require 'templates/main'

  render: ->
    @$el.html @template()
    @_renderContacts()
    this

  _renderContacts: ->
    @renderChild new ContactsView el: @$('#contacts')

module.exports = new Main(el: $('body')).render()
