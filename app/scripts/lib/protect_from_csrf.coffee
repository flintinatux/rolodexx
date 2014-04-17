session = require 'session'

Backbone._sync = Backbone.sync

Backbone.sync = (method, model, options) ->
  beforeSend = options.beforeSend

  # Set X-CSRF-Token HTTP header
  options.beforeSend = (xhr) ->
    xhr.setRequestHeader 'X-CSRF-Token', session.get('csrf_token')
    beforeSend.apply(this, arguments) if beforeSend

  Backbone._sync method, model, options
