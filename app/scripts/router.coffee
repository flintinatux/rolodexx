Contact = require 'models/contact'
ContactView = require 'views/contact'
EditView = require 'views/edit'
SwappingRouter = require 'lib/swapping_router'
contacts = require 'collections/contacts'

class Router extends SwappingRouter
  execute: (callback, args) ->
    @$el = $('#contact_wrapper')
    if contacts.isEmpty()
      contacts.fetch success: => super callback, args
    else
      super callback, args

  routes:
    '': 'home'
    'contacts': 'first'
    'contacts/new': 'new_contact'
    'contacts/:id': 'show'
    'contacts/:id/edit': 'edit'

  edit: (id) ->
    @_edit contacts.get(id)

  first: ->
    @_show contacts.first()

  home: ->
    @navigate '#/contacts', trigger: true, params: @params

  new_contact: ->
    @_edit new Contact()

  show: (id) ->
    @_show contacts.get(id)

  _edit: (contact) ->
    contacts.choose contact
    @swap new EditView model: contact, params: @params

  _show: (contact) ->
    contacts.choose contact
    @swap new ContactView model: contact, params: @params

module.exports = new Router()
