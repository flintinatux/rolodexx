SwappingRouter = require 'lib/swapping_router'

class Router extends SwappingRouter
  initialize: ->
    super()
    @$el = $('body')

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

module.exports = new Router()
