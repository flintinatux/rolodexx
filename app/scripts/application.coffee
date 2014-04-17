Application =
  initialize: ->
    require 'lib/protect_from_csrf'
    require 'views/main'
    require 'router'

module.exports = Application
