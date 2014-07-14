ContactsView = require 'views/contacts'
router = require 'router'

describe 'ContactsView', ->
  beforeEach ->
    @view = new ContactsView()
    @view.render()

  describe 'when the new button is clicked', ->
    beforeEach ->
      sandbox.spy router, 'navigate'
      @view.$('#new').click()

    it 'navigates to the new contact page', ->
      expect(router.navigate).to.have.been.calledWith '#/contacts/new', trigger: true
