Backbone.Model::validate = (attrs, options) ->
  errors = {}
  model = @

  validateObject = (fieldName, fieldValidations, value) ->
    objectErrors = {}
    for innerFieldName, innerFieldValidations of fieldValidations
      fieldErrors = applyValidations innerFieldName, innerFieldValidations, value[innerFieldName]
      if not _.isEmpty fieldErrors then objectErrors[innerFieldName] = fieldErrors
    objectErrors

  applyValidations = (fieldName, fieldValidations, value) ->
    fieldErrors = {}
    for validationName, option of fieldValidations
      error = if option is true
        validators[validationName].call null, value, attrs, model
      else
        validators[validationName].call null, option, value, attrs, model
      
      if error
        msg = getDisplayMessage error, validationName, option
        fieldErrors[validationName] = msg

    fieldErrors

  if @validations?
    _.each @validations, (fieldValidations, fieldName) ->
      value = attrs[fieldName]

      fieldErrors = if _.isObject value
        validateObject fieldName, fieldValidations, value
      else
        applyValidations fieldName, fieldValidations, value

      if not _.isEmpty fieldErrors then errors[fieldName] = fieldErrors

    if not _.isEmpty errors then return errors

hasValue = (value) ->
  value? and $.trim(value).length

validators = 
  required: (value, attrs) ->
    if not hasValue(value) then true

  min: (minValue, value, attrs) ->
    if hasValue(value) and value < minValue then true

  max: (maxValue, value, attrs) ->
    if hasValue(value) and value > maxValue then true

  range: (limits, value, attrs) ->
    if hasValue(value) and not (limits[0] <= value <= limits[1]) then true

  pattern: (expr, value, attrs) ->
    if hasValue(value) and not expr.test(value) then true

  email: (value, attrs) ->
    validators.pattern patterns.email, value, attrs

  url: (value, attrs) ->
    validators.pattern patterns.url, value, attrs

  custom: (fn, value, attrs, model) =>
    fn.call model, value, attrs

  # TODO:
  #   minlength
  #   maxlength
  #   lengthRange
  #   number
  #   in

patterns =
  email: /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i
  url: /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i

messages =
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

getDisplayMessage = (error, validationName, option) ->
  if _.isString error then getMessage(error) or error else getMessage validationName, option

getMessage = (validationName, option) ->
  msg = messages[validationName]
  if not msg then return false
  if not option then return msg

  if _.isObject(option) and not _.isRegExp(option)
    _.each option, (value, key) -> msg = msg.replace "{{#{key}}}", value
    msg
  else
    msg.replace "{{#{validationName}}}", option

Backbone.Validations = {}
Backbone.Validations.messages = messages