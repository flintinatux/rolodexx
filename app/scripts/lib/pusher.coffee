config = require 'config'
pusher = new Pusher(config.PUSHER_KEY).subscribe 'rolodexx'

events = [
  'contact:created'
  'contact:updated'
  'contact:destroyed'
]

_.each events, (event) ->
  [channel, name] = event.split ':'

  pusher.bind event, (data) ->
    Backbone.Radio.channel(channel).trigger name, data

module.exports = pusher
