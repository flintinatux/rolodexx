config = require 'config'
pusher = new Pusher config.PUSHER_KEY
socket = pusher.subscribe 'rolodexx'

# Register application events

events = [
  'contact:created'
  'contact:updated'
  'contact:destroyed'
]

_.each events, (event) ->
  [channel, name] = event.split ':'
  socket.bind event, (data) ->
    Backbone.Radio.channel(channel).trigger name, data

# Include Pusher socket_id in header

originalSync = Backbone.sync

Backbone.sync = (method, model, options) ->
  if pusher.connection.state == 'connected'
    options.headers = _.extend(
      { 'X-Pusher-Socket-Id': pusher.connection.socket_id }, options.headers
    )
  originalSync method, model, options

module.exports = pusher
