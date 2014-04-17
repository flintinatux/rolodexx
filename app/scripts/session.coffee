class Session extends Backbone.Model
  url: '/session'

session = new Session()
session.fetch()
module.exports = session
