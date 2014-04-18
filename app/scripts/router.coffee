Contact = require 'models/contact'
ContactView = require 'views/contact'
SwappingRouter = require 'lib/swapping_router'
contacts = require 'collections/contacts'

class Router extends SwappingRouter
  execute: (callback, args) ->
    @$el = $('#contact_wrapper')
    super callback, args

  routes:
    '': 'home'
    'contacts': 'first'
    'contacts/new': 'new_contact'
    'contacts/:id': 'show'
    'contacts/:id/edit': 'edit'

  edit: (id) ->

  first: ->

  home: ->
    @navigate '#/contacts', trigger: true, params: @params

  new_contact: ->

  show: (id) ->
    contacts.fetch success: =>
      model = contacts.get id
      model.set active: true
      @swap new ContactView model: model, params: @params

module.exports = new Router()
