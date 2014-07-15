session = require 'session'

originalSync = Backbone.sync

Backbone.sync = (method, model, options) ->
  options.headers = _.extend(
    { 'X-CSRF-Token': session.get('csrf_token') }, options.headers
  )
  originalSync method, model, options
