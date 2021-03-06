CompositeView = require 'lib/composite_view'

class ContactView extends CompositeView
  template: require 'templates/contact'
  id: 'contact'

  addressBindings:
    '#street':    'street'
    '#city':
      observe: 'city'
      onGet: (val) -> if val then "#{val}, "
    '#state':     'state'
    '#postcode':  'postcode'

  bindings:
    '#age': 'age'
    '#avatar':
      attributes: [
        name: 'src'
        observe: 'gravatar_hash'
        onGet: (val) -> "http://www.gravatar.com/avatar/#{val}?d=mm&s=256"
      ]
    '#birthday':
      observe: 'birthday'
      onGet: (val) -> if val then moment(val).format('M / D / YYYY')
    '#email': 'email'
    '#name':  'name'
    '#phone': 'phone'
    '#sex':   'sex'

  events:
    'click #edit': '_editContact'

  tooltipOptions:
    placement: 'right'
    delay:
      show: 500
      hide: 100

  initialize: (options) ->
    super options
    @listenTo @model, 'remove', @_goHome

  render: ->
    @$el.html @template()
    @stickit()
    @stickit @model.get('address'), @addressBindings
    @_enableTooltips()
    this

  _editContact: ->
    require('router').navigate "#/contacts/#{@model.id}/edit", trigger: true

  _enableTooltips: ->
    @$('[data-toggle=tooltip]').tooltip @tooltipOptions

  _goHome: ->
    require('router').navigate "#/contacts", trigger: true

module.exports = ContactView
