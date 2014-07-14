Card    = require 'views/card'
Contact = require 'models/contact'
router  = require 'router'

describe 'Card', ->
  beforeEach ->
    sandbox.spy Card::, 'remove'
    @gravatarHash = 'abcdef'
    @name = 'Scott'
    @contact = new Contact id: 1, name: @name, gravatar_hash: @gravatarHash
    @view = new Card model: @contact
    @view.render()

  describe 'when the model is removed', ->
    beforeEach ->
      @contact.trigger 'remove'

    it 'removes the view', ->
      expect(Card::remove).to.have.been.called

  describe 'when the card is clicked', ->
    beforeEach ->
      sandbox.spy router, 'navigate'
      @view.$el.click()

    it 'navigates to show the contact', ->
      expect(router.navigate).to.have.been.calledWith "##{@contact.url()}", trigger: true

  describe 'when the contact is active', ->
    beforeEach ->
      @contact.set active: true

    it 'marks the card as active', ->
      expect(@view.$el).to.have.class 'active'

  describe 'when the contact is inactive', ->
    beforeEach ->
      @contact.set active: false

    it 'does not mark the card as active', ->
      expect(@view.$el).not.to.have.class 'active'

  it 'binds the gravatar url', ->
    expect(@view.$('#avatar')).to.have.attr 'src', "http://www.gravatar.com/avatar/#{@gravatarHash}?d=mm&s=32"

  it 'binds the name', ->
    expect(@view.$('#name')).to.have.text @name
