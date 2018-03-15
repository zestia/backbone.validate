class @BackboneValidate
  constructor: (@attrs, @validations, @model) ->
    @errors = {}

  validate: =>
    if @validations?
      for fieldName, fieldValidations of @validations
        fieldDetails = @parseName fieldName

        continue unless fieldDetails?

        if _.isArray(fieldDetails.value)
          for value, index in fieldDetails.value
            fieldErrors = @applyValidations value, fieldValidations
            errorsKey = fieldDetails.fullName.replace /\[\]/, "[#{index}]"
            if not _.isEmpty fieldErrors then @errors[errorsKey] = fieldErrors
        else
          fieldErrors = @applyValidations fieldDetails.value, fieldValidations
          if not _.isEmpty fieldErrors then @errors[fieldDetails.fullName] = fieldErrors

      if not _.isEmpty @errors then return @errors

  parseName: (name) ->
    if /(\.?\w+\[\]){2,}/.test(name) then throw new Error('Backbone.Validate: Nested arrays not supported')
    if /\[\](\.\w+){2,}/.test(name) then throw new Error('Backbone.Validate: Nesting within an array not supported')

    fullName = name
    index = /\[(\d*)\]/.exec(fullName)?[1]
    tokens = name.split('.')
    value = null

    for t in tokens
      name = t.replace /\[(\d+)?\]$/, ''

      value = if not value?
        @attrs[name]
      else if _.isArray(value)
        _.map value, name
      else
        value[name]

    value = value[index] if index? and index.length > 0 and value?

    { name: name, fullName: fullName, value: value }

  applyValidations: (value, fieldValidations) ->
    fieldErrors = {}
    for validationName, option of fieldValidations
      args = (if option is true then [] else [option]).concat([value, @attrs, @model])
      error = BackboneValidate.validators[validationName].apply BackboneValidate.validators, args
      if error then fieldErrors[validationName] = @getDisplayMessage error, validationName, option
    fieldErrors

  @validators:
    hasValue: (value) ->
      value? and $.trim(value).length isnt 0

    required: (value, attrs) ->
      not @hasValue(value)

    min: (minValue, value, attrs) ->
      if @hasValue(value) and value < minValue then true

    max: (maxValue, value, attrs) ->
      if @hasValue(value) and value > maxValue then true

    range: (limits, value, attrs) ->
      @hasValue(value) and not (limits[0] <= value <= limits[1])

    pattern: (expr, value, attrs) ->
      if @hasValue(value) and not expr.test(value) then true else false

    email: (value, attrs) ->
      if /[\u00E0-\u00FC]+/i.test(value)
        return true

      @pattern BackboneValidate.patterns.email, value, attrs

    url: (value, attrs) ->
      @pattern BackboneValidate.patterns.url, value, attrs

    custom: (fn, value, attrs, model) ->
      fn.call model, value, attrs

    maxLength: (maxLength, value, attrs) ->
      return false unless @hasValue(value)
      value.toString().length > maxLength

    minLength: (minLength, value, attrs) ->
      return false unless @hasValue(value)
      value.toString().length < minLength

    lengthRange: (range, value, attrs) ->
      return true unless @hasValue(value)
      range[0] > value.toString().length or range[1] < value.toString().length

    # TODO:
    #   number
    #   in

  @patterns:
    email: /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i

    url: /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i

  @messages:
    required: 'is required'
    min: 'must be greater than or equal to {{min}}'
    max: 'must be less than or equal to {{max}}'
    range: 'must be between {{0}} and {{1}}'

    minLength: 'length must be greater than or equal to {{minLength}}'
    maxLength: 'length must be less than or equal to {{maxLength}}'
    lengthRange: 'length must be between {{0}} and {{1}}'

    pattern: 'must match {{pattern}}'
    email: 'must be a well-formed email address'
    url: 'must be a well-formed URL'

    past: 'must be a past date'
    future: 'must be a future date'

  getDisplayMessage: (error, validationName, option) ->
    if _.isString error then @getMessage(error) or error else @getMessage validationName, option

  getMessage: (validationName, option) ->
    msg = BackboneValidate.messages[validationName]
    if not msg then return false
    if not option then return msg

    if _.isObject(option) and not _.isRegExp(option)
      msg = msg.replace "{{#{key}}}", value for key, value of option
      msg
    else
      msg.replace "{{#{validationName}}}", option

if Backbone?
  Backbone.Model::validate = (attrs, options) ->
    new BackboneValidate(attrs, @validations, @).validate()
