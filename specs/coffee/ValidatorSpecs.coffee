describe 'Default validators', ->

  it 'should be exposed', ->
    expect(BackboneValidate.validators).toBeDefined()


  describe 'the "required" validator', ->

    it 'should be exposed', ->
      expect(BackboneValidate.validators.required).toBeDefined()

    it 'should return false when a value is provided', ->
      expect(BackboneValidate.validators.required('testy')).toBe(false)

    it 'should return true when a value is not provided', ->
      expect(BackboneValidate.validators.required(undefined)).toBe(true)
      expect(BackboneValidate.validators.required(null)).toBe(true)
      expect(BackboneValidate.validators.required('')).toBe(true)


  describe 'the "range" validator', ->

    it 'should be exposed', ->
      expect(BackboneValidate.validators.range).toBeDefined()

    it 'should return false when a value isnt provided', ->
      expect(BackboneValidate.validators.range([1, 10], undefined)).toBe(false)
      expect(BackboneValidate.validators.range([1, 10], null)).toBe(false)
      expect(BackboneValidate.validators.range([1, 10], '')).toBe(false)

    it 'should return undefined when the value is within the specified range', ->
      expect(BackboneValidate.validators.range([1, 10], 5)).toBe(false)

    it 'should return true when the value is outside the specified range', ->
      expect(BackboneValidate.validators.range([1, 10], 0)).toBe(true)
      expect(BackboneValidate.validators.range([1, 10], 11)).toBe(true)


  describe 'the "custom" validator', ->

    it 'should be exposed', ->
      expect(BackboneValidate.validators.custom).toBeDefined()

    it 'should call the provided function with the correct parameters', ->
      fn = jasmine.createSpy()
      value = ''
      attrs = {}
      BackboneValidate.validators.custom(fn, value, attrs)
      expect(fn).toHaveBeenCalledWith(value, attrs)

    it 'should return the result of the provided function', ->
      expect(BackboneValidate.validators.custom(-> true)).toBe(true)
      expect(BackboneValidate.validators.custom(-> false)).toBe(false)
      expect(BackboneValidate.validators.custom(->)).toBeUndefined


  describe 'the "email" validator', ->

    it 'should be exposed', ->
      expect(BackboneValidate.validators.email).toBeDefined()

    it 'should return false when a valid email address is provided', ->
      expect(BackboneValidate.validators.email('test@example.net')).toBe(false)

    it 'should return true when an invalid email address is provided', ->
      expect(BackboneValidate.validators.email('abcd')).toBe(true)


  describe 'the "maxLength" validator', ->

    it 'should be exposed', ->
      expect(BackboneValidate.validators.maxLength).toBeDefined()

    it 'should return false when a value not longer than max length provided', ->
      expect(BackboneValidate.validators.maxLength(6, 'Hello')).toBe(false)

    it 'should return true when a value longer than max length provided', ->
      expect(BackboneValidate.validators.maxLength(6, 'Hello World')).toBe(true)


  describe 'the "minLength" validator', ->

    it 'should be exposed', ->
      expect(BackboneValidate.validators.minLength).toBeDefined()

    it 'should return false when a value is longer than min length provided', ->
      expect(BackboneValidate.validators.minLength(4, 'Hello')).toBe(false)

    it 'should return true when a value shorter than min length provided', ->
      expect(BackboneValidate.validators.minLength(16, 'Hello World')).toBe(true)


  describe 'the "lengthRange" validator', ->
    it 'should be exposed', ->
      expect(BackboneValidate.validators.lengthRange).toBeDefined()

    it 'should return false when a value length is inside the length range provided', ->
      expect(BackboneValidate.validators.lengthRange([4, 10], 'Hello')).toBe(false)

    it 'should return true when a value length is outside of the length range provided', ->
      expect(BackboneValidate.validators.lengthRange([1, 5], 'Hello World')).toBe(true)
