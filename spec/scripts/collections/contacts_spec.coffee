Contact = require 'models/contact'

describe 'Contacts', ->
  beforeEach ->
    @contacts = require 'collections/contacts'
    @hanz  = new Contact id: 1, name: 'Hanz'
    @franz = new Contact id: 2, name: 'Franz'
    @contacts.add [@hanz, @franz]

  it 'has the right url', ->
    expect(_.result @contacts, 'url').to.equal '/contacts'

  it 'uses the Contact model', ->
    expect(@contacts.model.name).to.equal 'Contact'

  it 'sorts based on name', ->
    expect(@contacts.last().get 'name').to.eql 'Hanz'

  describe '#choose', ->
    beforeEach ->
      sinon.spy @contacts, 'invoke'
      @contacts.choose @hanz

    it 'invokes down to the models', ->
      expect(@contacts.invoke).to.have.been.calledWith 'choose', @hanz
