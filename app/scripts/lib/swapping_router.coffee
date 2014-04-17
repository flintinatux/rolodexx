class SwappingRouter extends Backbone.Router
  execute: (callback, args) ->
    @params = @_parseParams args.pop()
    callback?.apply this, args

  navigate: (fragment, options={}) ->
    url = new URI fragment.replace('#','')
    url.query options.params if options.params?
    super "##{url.toString()}", _.omit(options, 'params')

  swap: (newView) ->
    @currentView?.remove()
    @currentView = newView
    @$el.html @currentView.render().el
    @currentView.swapped()
    this

  _parseParams: (params) ->
    return {} unless params
    new URI("?#{params}").query(true)

module.exports = SwappingRouter
