(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.BackboneValidate = (function() {
    function BackboneValidate(attrs, validations, model) {
      this.attrs = attrs;
      this.validations = validations;
      this.model = model;
      this.validate = __bind(this.validate, this);
      this.errors = {};
    }

    BackboneValidate.prototype.validate = function() {
      var errorsKey, fieldDetails, fieldErrors, fieldName, fieldValidations, index, value, _i, _len, _ref, _ref1;
      if (this.validations != null) {
        _ref = this.validations;
        for (fieldName in _ref) {
          fieldValidations = _ref[fieldName];
          fieldDetails = this.parseName(fieldName);
          if (_.isArray(fieldDetails.value)) {
            _ref1 = fieldDetails.value;
            for (index = _i = 0, _len = _ref1.length; _i < _len; index = ++_i) {
              value = _ref1[index];
              fieldErrors = this.applyValidations(value, fieldValidations);
              errorsKey = fieldDetails.fullName.replace(/\[\]/, "[" + index + "]");
              if (!_.isEmpty(fieldErrors)) {
                this.errors[errorsKey] = fieldErrors;
              }
            }
          } else {
            fieldErrors = this.applyValidations(fieldDetails.value, fieldValidations);
            if (!_.isEmpty(fieldErrors)) {
              this.errors[fieldDetails.fullName] = fieldErrors;
            }
          }
        }
        if (!_.isEmpty(this.errors)) {
          return this.errors;
        }
      }
    };

    BackboneValidate.prototype.parseName = function(name) {
      var fullName, t, tokens, value, _i, _len;
      if (/(\.?\w+\[\]){2,}/.test(name)) {
        throw new Error('Backbone.Validate: Nested arrays not supported');
      }
      if (/\[\](\.\w+){2,}/.test(name)) {
        throw new Error('Backbone.Validate: Nesting within an array not supported');
      }
      fullName = name;
      tokens = name.split('.');
      value = null;
      for (_i = 0, _len = tokens.length; _i < _len; _i++) {
        t = tokens[_i];
        name = t.replace(/\[\]$/, '');
        value = value == null ? this.attrs[name] : _.isArray(value) ? _.pluck(value, name) : value[name];
      }
      return {
        name: name,
        fullName: fullName,
        value: value
      };
    };

    BackboneValidate.prototype.applyValidations = function(value, fieldValidations) {
      var args, error, fieldErrors, option, validationName;
      fieldErrors = {};
      for (validationName in fieldValidations) {
        option = fieldValidations[validationName];
        args = (option === true ? [] : [option]).concat([value, this.attrs, this.model]);
        error = BackboneValidate.validators[validationName].apply(BackboneValidate.validators, args);
        if (error) {
          fieldErrors[validationName] = this.getDisplayMessage(error, validationName, option);
        }
      }
      return fieldErrors;
    };

    BackboneValidate.validators = {
      hasValue: function(value) {
        return (value != null) && $.trim(value).length !== 0;
      },
      required: function(value, attrs) {
        return !this.hasValue(value);
      },
      min: function(minValue, value, attrs) {
        if (this.hasValue(value) && value < minValue) {
          return true;
        }
      },
      max: function(maxValue, value, attrs) {
        if (this.hasValue(value) && value > maxValue) {
          return true;
        }
      },
      range: function(limits, value, attrs) {
        return this.hasValue(value) && !((limits[0] <= value && value <= limits[1]));
      },
      pattern: function(expr, value, attrs) {
        if (this.hasValue(value) && !expr.test(value)) {
          return true;
        } else {
          return false;
        }
      },
      email: function(value, attrs) {
        return this.pattern(BackboneValidate.patterns.email, value, attrs);
      },
      url: function(value, attrs) {
        return this.pattern(BackboneValidate.patterns.url, value, attrs);
      },
      custom: function(fn, value, attrs, model) {
        return fn.call(model, value, attrs);
      },
      maxLength: function(maxLength, value, attrs) {
        return value.toString().length > maxLength;
      },
      minLength: function(minLength, value, attrs) {
        return value.toString().length < minLength;
      },
      lengthRange: function(min, max, value, attrs) {
        return min > value.toString().length || max < value.toString().length;
      }
    };

    BackboneValidate.patterns = {
      email: /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i,
      url: /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i
    };

    BackboneValidate.messages = {
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

    BackboneValidate.prototype.getDisplayMessage = function(error, validationName, option) {
      if (_.isString(error)) {
        return this.getMessage(error) || error;
      } else {
        return this.getMessage(validationName, option);
      }
    };

    BackboneValidate.prototype.getMessage = function(validationName, option) {
      var key, msg, value;
      msg = BackboneValidate.messages[validationName];
      if (!msg) {
        return false;
      }
      if (!option) {
        return msg;
      }
      if (_.isObject(option) && !_.isRegExp(option)) {
        for (key in option) {
          value = option[key];
          msg = msg.replace("{{" + key + "}}", value);
        }
        return msg;
      } else {
        return msg.replace("{{" + validationName + "}}", option);
      }
    };

    return BackboneValidate;

  })();

  if (typeof Backbone !== "undefined" && Backbone !== null) {
    Backbone.Model.prototype.validate = function(attrs, options) {
      return new BackboneValidate(attrs, this.validations, this).validate();
    };
  }

}).call(this);
