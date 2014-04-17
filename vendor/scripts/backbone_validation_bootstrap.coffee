Backbone.Validation.configure
  selector: 'id'

_.extend Backbone.Validation.callbacks,
  valid: (view, attr, selector) ->
    control = view.$("[#{selector}=#{attr}]")
    control.parents('.form-group').removeClass 'has-error'
    control.siblings('.form-control-feedback').text ''

  invalid: (view, attr, error, selector) ->
    control = view.$("[#{selector}=#{attr}]")
    control.parents('.form-group').addClass 'has-error'
    control.siblings('.form-control-feedback').text error
