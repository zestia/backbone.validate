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
      expect(BackboneValidate.validators.pattern).toBeDefined()

    it 'should return false when a valid email address is provided', ->
      expect(BackboneValidate.validators.pattern('email', 'test@example.net')).toBe(false)

    it 'should return true when an invalid email address is provided', ->
      expect(BackboneValidate.validators.pattern('email', 'abcd')).toBe(true)