Application =
  initialize: ->
    require 'lib/protect_from_csrf'
    require 'lib/pusher'
    require 'views/main'
    require 'router'

module.exports = Application
