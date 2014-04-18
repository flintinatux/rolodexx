CompositeView = require 'lib/composite_view'
router = require 'router'

class Card extends CompositeView
  template: require 'templates/card'
  className: 'card'

  bindings:
    ':el':
      attributes: [
        name: 'class'
        observe: 'active'
        onGet: (val) -> if val then 'active' else ''
      ]
    '#avatar':
      attributes: [
        name: 'src'
        observe: 'gravatar_hash'
        onGet: (val) -> "http://www.gravatar.com/avatar/#{val}?d=mm&s=32"
      ]
    '#name': 'name'

  events:
    'click': '_showContact'

  render: ->
    @$el.html @template()
    @stickit()
    this

  _showContact: ->
    router.navigate "#/contacts/#{@model.id}", trigger: true

module.exports = Card
