class Contacts extends Backbone.Collection
  url: '/contacts'
  model: require 'models/contact'
  comparator: 'name'

  initialize: (models, options) ->
    super models, options
    @channel = Backbone.Radio.channel _.result(this,'url')
    @listenTo @channel, 'created',   (model) => @add model
    @listenTo @channel, 'destroyed', (model) => @remove model

  choose: (contact) ->
    @invoke 'choose', contact

module.exports = new Contacts()
