class Contacts extends Backbone.Collection
  url: '/contacts'
  model: require 'models/contact'
  comparator: 'name'
  channel: Backbone.Radio.channel 'contact'

  initialize: (models, options) ->
    @listenTo @channel, 'created',   (model) => @add model
    @listenTo @channel, 'updated',   (model) => @add model, merge: true
    @listenTo @channel, 'destroyed', (model) => @remove model

  choose: (contact) ->
    @invoke 'choose', contact

module.exports = new Contacts()
