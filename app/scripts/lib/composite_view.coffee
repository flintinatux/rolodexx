class CompositeView extends Backbone.View
  initialize: (options) ->
    super(options)
    @children = _([])

  renderChild: (child) ->
    @children.push child
    child.parent = this
    child.render()

  remove: ->
    @trigger 'remove'
    super()
    @_removeChildren()
    @_removeFromParent()
    this

  swapped: ->
    @trigger 'swapped'
    this

  _removeChild: (child) ->
    index = @children.indexOf child
    @children.splice index, 1

  _removeChildren: ->
    _.each @children.clone(), (child) ->
      child.remove()

  _removeFromParent: ->
    @parent._removeChild(this) if @parent

module.exports = CompositeView
