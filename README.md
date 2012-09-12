# Backbone.Validate

Simple Backbone model validation

## Getting Started
Download the [production version][min] or the [development version][max].

[min]: https://raw.github.com/zestia/backbone.validate/master/dist/backbone.validate.min.js
[max]: https://raw.github.com/zestia/backbone.validate/master/dist/backbone.validate.js

## Documentation
_(Coming soon)_

## Examples

```coffeescript
class Person extends Backbone.Model
  validations:
    name:
      required: true
      minLength: 3
    emailAddress:
      email: true
    age:
      range: [0, 200]
```

## Release History
_(Nothing yet)_

## License
Copyright (c) 2012 Ross Grayton  
Licensed under the MIT license.