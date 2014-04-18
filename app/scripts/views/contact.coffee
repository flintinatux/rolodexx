CompositeView = require 'lib/composite_view'

class ContactView extends CompositeView
  template: require 'templates/contact'
  id: 'contact'

  render: ->
    @$el.html @template()
    this

module.exports = ContactView
