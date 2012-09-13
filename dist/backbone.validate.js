/*! Backbone Validate - v0.1.0 - 2012-09-13
* https://github.com/zestia/backbone.validate
* Copyright (c) 2012 Ross Grayton; Licensed MIT */

(function() {
  var getMessage, hasValue, messages, patterns, validators,
    _this = this;

  Backbone.Model.prototype.validate = function(attrs, options) {
    var errors, model;
    errors = {};
    model = this;
    if (this.validations != null) {
      _.each(this.validations, function(fieldValidations, fieldName) {
        var value;
        value = attrs[fieldName];
        return _.each(fieldValidations, function(option, validationName) {
          var error, _ref;
          error = option === true ? validators[validationName].call(null, value, attrs, model) : validators[validationName].call(null, option, value, attrs, model);
          if (error) {
            return ((_ref = errors[fieldName]) != null ? _ref : errors[fieldName] = {})[validationName] = _.isString(error) ? getMessage(error) || error : getMessage(validationName, option);
          }
        });
      });
      if (!_.isEmpty(errors)) {
        return errors;
      }
    }
  };

  hasValue = function(value) {
    return (value != null) && $.trim(value).length;
  };

  validators = {
    required: function(value, attrs) {
      if (!hasValue(value)) {
        return true;
      }
    },
    min: function(minValue, value, attrs) {
      if (hasValue(value) && value < minValue) {
        return true;
      }
    },
    max: function(maxValue, value, attrs) {
      if (hasValue(value) && value > maxValue) {
        return true;
      }
    },
    range: function(limits, value, attrs) {
      if (hasValue(value) && !((limits[0] <= value && value <= limits[1]))) {
        return true;
      }
    },
    pattern: function(expr, value, attrs) {
      if (hasValue(value) && !expr.test(value)) {
        return true;
      }
    },
    email: function(value, attrs) {
      return validators.pattern(patterns.email, value, attrs);
    },
    url: function(value, attrs) {
      return validators.pattern(patterns.url, value, attrs);
    },
    custom: function(fn, value, attrs, model) {
      return fn.call(model, value, attrs);
    }
  };

  patterns = {
    email: /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i,
    url: /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
  };

  messages = {
    required: 'is required',
    min: 'must be greater than or equal to {{min}}',
    max: 'must be less than or equal to {{max}}',
    range: 'must be between {{0}} and {{1}}',
    minLength: 'length must be greater than or equal to {{minLength}}',
    maxLength: 'length must be less than or equal to {{maxLength}}',
    lengthRange: 'length must be between {{0}} and {{1}}',
    pattern: 'must match {{pattern}}',
    email: 'must be a well-formed email address',
    url: 'must be a well-formed URL',
    past: 'must be a past date',
    future: 'must be a future date'
  };

  getMessage = function(validationName, option) {
    var msg;
    msg = messages[validationName];
    if (!msg) {
      return false;
    }
    if (!option) {
      return msg;
    }
    if (_.isObject(option) && !_.isRegExp(option)) {
      _.each(option, function(value, key) {
        return msg = msg.replace("{{" + key + "}}", value);
      });
      return msg;
    } else {
      return msg.replace("{{" + validationName + "}}", option);
    }
  };

  Backbone.Validations = {};

  Backbone.Validations.messages = messages;

}).call(this);
