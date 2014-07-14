Contact  = require 'models/contact'
contacts = require 'collections/contacts'

describe 'Contact', ->
  beforeEach ->
    @id     = 'contact_id'
    @name   = 'Scott'
    @email  = 'scott@gmail.com'
    @address =
      id: 1
      street: 'Abc St.'
      city: 'Atlanta'
      state: 'GA'
      postcode: '30120'

    _.extend Contact::, Backbone.Validation.mixin
    @contact = new Contact id: @id, name: @name, email: @email, address: @address

  it 'has the right url', ->
    expect(_.result @contact, 'url').to.equal "/contacts/#{@id}"

  it 'is valid', ->
    expect(@contact.isValid true).to.be.true

  it 'has a nested Address model', ->
    expect(@contact.get('address').constructor.name).to.equal 'Address'

  describe 'when name is blank', ->
    beforeEach ->
      @contact.set name: null

    it 'is not valid', ->
      expect(@contact.isValid true).to.be.false

  describe 'when email is blank', ->
    beforeEach ->
      @contact.set email: null

    it 'is valid', ->
      expect(@contact.isValid true).to.be.true

  describe 'when email is not a valid email', ->
    beforeEach ->
      @contact.set email: 'not-a#valid@email'

    it 'is not valid', ->
      expect(@contact.isValid true).to.be.false

  describe '#choose', ->
    beforeEach ->
      contacts.add [{ id: 1, active: true }, { id: 2, active: false }]
      @contact = contacts.last()

    describe 'when this contact is chosen', ->
      beforeEach ->
        @contact.choose @contact

      it 'sets this contact as active', ->
        expect(@contact.get 'active').to.be.true

    describe 'when this contact not chosen', ->
      beforeEach ->
        @contact.choose contacts.first()

      it 'sets this contact as inactive', ->
        expect(@contact.get 'active').to.be.false

  describe '/contacts/:id events', ->
    beforeEach ->
      @channel = @contact.channel

    describe 'updated', ->
      beforeEach ->
        @newName = 'Scotty'
        @channel.trigger 'updated', _.extend(_.clone(@contact.attributes), name: @newName)

      it 'updates the model', ->
        expect(@contact.get 'name').to.equal @newName
