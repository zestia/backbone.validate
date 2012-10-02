describe 'Validating attributes', ->

  it 'should return undefined when there are no validations (undefined, null or empty object)', ->
    attrs = { one: 'one' }
    expect(new BackboneValidate(attrs, undefined).validate()).toBeUndefined()
    expect(new BackboneValidate(attrs, null).validate()).toBeUndefined()
    expect(new BackboneValidate(attrs, {}).validate()).toBeUndefined()

  it 'should return undefined when there are no errors', ->
    attrs = { one: 'one' }
    validations = { one: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors).toBeUndefined()

  it 'should return an object when there are errors', ->
    attrs = { one: '' }
    validations = { one: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors).toBeDefined()

  it 'should return details of any errors, including an error message for each', ->
    attrs = { one: '' }
    validations = { one: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.one).toBeDefined()
    expect(errors.one.required).toBeDefined()
    expect(errors.one.required).toBe('is required')

  it 'shouldnt return any extra crap', ->
    attrs = { one: '' }
    validations = { one: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors).toEqual({ one: { required: 'is required' } })

  it 'should be able to validate multiple attributes', ->
    attrs = { one: '', two: '' }
    validations = { one: { required: true }, two: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.one).toBeDefined()
    expect(errors.two).toBeDefined()

  it 'should be able to apply multiple validations to an attribute', ->
    attrs = { one: '' }
    validations = { one: { required: true, custom: -> true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.one).toBeDefined()
    expect(errors.one.required).toBeDefined()
    expect(errors.one.custom).toBeDefined()


describe 'Validating objects', ->

  it 'should validate attributes that are objects', ->
    attrs = { email: { address: '', type: '' } }
    validations = { email: { address: { required: true }, type: { required: true } } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.email.address.required).toBe('is required')
    expect(errors.email.type.required).toBe('is required')


describe 'Validating arrays', ->

  it 'should validate attributes that are arrays', ->
    attrs = { email: ['', ''] }
    validations = { email: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.email[0].required).toBe('is required')
    expect(errors.email[1].required).toBe('is required')

  it 'should only return the index of elements that fail validation', ->
    attrs = { email: ['one', ''] }
    validations = { email: { required: true } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.email[1].required).toBe('is required')


describe 'Validating arrays of objects', ->

  it 'should validate attributes that are arrays', ->
    attrs = { email: [{ address: '', type: '' }, { address: '', type: '' }] }
    validations = { email: { address: { required: true }, type: { required: true } } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.email[0].address.required).toBe('is required')
    expect(errors.email[0].type.required).toBe('is required')
    expect(errors.email[1].address.required).toBe('is required')
    expect(errors.email[1].type.required).toBe('is required')

  it 'should only return the index of elements that fail validation', ->
    attrs = { email: [{ address: 'one', type: 'one' }, { address: '', type: '' }] }
    validations = { email: { address: { required: true }, type: { required: true } } }
    errors = new BackboneValidate(attrs, validations).validate()
    expect(errors.email[0]).toBeUndefined()
    expect(errors.email[1].address.required).toBe('is required')
    expect(errors.email[1].type.required).toBe('is required')