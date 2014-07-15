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
      sandbox.spy @contacts, 'invoke'
      @contacts.choose @hanz

    it 'invokes down to the models', ->
      expect(@contacts.invoke).to.have.been.calledWith 'choose', @hanz

  describe 'contact events', ->
    beforeEach ->
      @channel = Backbone.Radio.channel 'contact'

    describe 'contact:created', ->
      beforeEach ->
        @newContact = id: 3, name: 'Scott'
        @channel.trigger 'created', @newContact

      it 'adds the contact to the collection', ->
        contact = @contacts.get @newContact.id
        expect(contact.get 'name').to.equal @newContact.name

    describe 'contact:updated', ->
      beforeEach ->
        @newName = 'Scotty'
        @channel.trigger 'updated', _.extend(_.clone(@hanz.attributes), name: @newName)

      it 'updates the model', ->
        expect(@contacts.get(@hanz.id).get 'name').to.equal @newName

    describe 'contact:destroyed', ->
      beforeEach ->
        @channel.trigger 'destroyed', @hanz.attributes

      it 'removes the contact from the collection', ->
        expect(@contacts.get @hanz.id).to.be.undefined
