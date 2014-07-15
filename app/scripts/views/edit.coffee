CompositeView = require 'lib/composite_view'

class EditView extends CompositeView
  template: require 'templates/edit'
  id: 'contact'

  addressBindings:
    '#street': 'street'
    '#city':   'city'
    '#state':
      observe: 'state'
      selectOptions:
        collection: require 'lib/states'
        defaultOption: { label: "State", value: null }
    '#postcode': 'postcode'

  bindings:
    '#avatar':
      attributes: [
        name: 'src'
        observe: 'gravatar_hash'
        onGet: (val) -> "http://www.gravatar.com/avatar/#{val}?d=mm&s=256"
      ]
    '#birthday':  'birthday'
    '#delete':
      attributes: [
        name: 'class'
        observe: 'id'
        onGet: (val) -> if val then '' else 'hidden'
      ]
    '#email':     'email'
    '#name':      'name'
    '#phone':     'phone'
    '#sex':
      observe: 'sex'
      selectOptions:
        collection: ['male', 'female']
        defaultOption: { label: "Choose one...", value: null }

  events:
    'click #cancel': '_cancel'
    'click #delete': '_delete'
    'submit form':   '_saveAndShow'

  initialize: (options) ->
    super options
    @collection = require 'collections/contacts'
    @model.set(address: {}) unless @model.get('address')
    @listenTo @model, 'change', @_markDirty
    @listenTo @model, 'remove', @_removed

  remove: ->
    if @dirty
      if window.confirm 'You have unsaved changes. Do you want to save before continuing?'
        @_saveContact()
      else
        @model.undo()
    super()

  render: ->
    @$el.html @template()
    @stickit()
    @stickit @model.get('address'), @addressBindings
    Backbone.Validation.bind this, model: @model
    this

  _cancel: ->
    @model.undo()
    @dirty = false
    if @model.isNew() then @_goHome() else @_show()

  _delete: ->
    if window.confirm 'Are you sure you want to delete this contact?'
      @dirty = false
      @model.destroy success: => @_goHome()

  _goHome: ->
    require('router').navigate "#/contacts", trigger: true

  _markDirty: (model, options) ->
    @dirty = true unless model.hasChanged('active')

  _removed: ->
    @dirty = false
    @_goHome()

  _saveAndShow: (event) ->
    event.preventDefault()
    @_saveContact success: @_show

  _saveContact: (options={}) ->
    return unless @model.isValid(true)
    @model.save {}, nested: true, success: =>
      @dirty = false
      @collection.add @model
      @collection.sort()
      options.success?.apply this

  _show: ->
    require('router').navigate "##{@model.url()}", trigger: true

module.exports = EditView
