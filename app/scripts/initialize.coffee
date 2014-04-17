application = require 'application'

$(document).ready ->
  application.initialize()
  Backbone.history.start pushState: false
