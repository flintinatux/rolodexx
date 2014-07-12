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
    expect(@contact.url()).to.equal "/contacts/#{@id}"

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
      @contact.choose()

    it 'sets this contact as active', ->
      expect(@contact.get 'active').to.be.true

    it 'sets the other contacts as inactive', ->
      expect(contacts.first().get 'active').to.be.false
