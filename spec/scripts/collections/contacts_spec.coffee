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

  describe '/contacts events', ->
    beforeEach ->
      @channel = @contacts.channel

    describe 'created', ->
      beforeEach ->
        @newContact = id: 3, name: 'Scott'
        @channel.trigger 'created', @newContact

      it 'adds the contact to the collection', ->
        contact = @contacts.get @newContact.id
        expect(contact.get 'name').to.equal @newContact.name

    describe 'destroyed', ->
      beforeEach ->
        @channel.trigger 'destroyed', @hanz.attributes

      it 'removes the contact from the collection', ->
        expect(@contacts.get @hanz.id).to.be.undefined
