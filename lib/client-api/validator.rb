module ClientApi

  def validate(options = {})
    raise_error('key (or) operator is not given!') if options[:key].nil? && options[:operator].nil?
    raise_error('value (or) type is not given!') if options[:value].nil? && options[:type].nil?

    key = options[:key]
    value = options[:value] if options[:value]
    operator = options[:operator]
    type = options[:type] if options[:type] || options[:type] != {} || !options[:type].empty?

    case operator
    when '=', '==', 'eql?', 'equal', 'equal?'
      expect(body[key]).to eq(value) if value
      expect(body[key].class).to eq(datatype(type)) if type
    when '!', '!=', '!eql?', 'not equal', '!equal?'
      expect(body[key]).not eq(value) if value
      expect(body[key].class).not eq(datatype(type)) if type
    else
      raise_error('operator not matching')
    end
  end

  def datatype(type)
    if (type.downcase == 'string') || (type.downcase.== 'str')
      String
    elsif (type.downcase.== 'integer') || (type.downcase.== 'int')
      Integer
    elsif (type.downcase == 'symbol') || (type.downcase == 'sym')
      Symbol
    elsif (type.downcase == 'array') || (type.downcase == 'arr')
      Array
    elsif (type.downcase == 'object') || (type.downcase == 'obj')
      Object
    elsif type.downcase == 'float'
      Float
    elsif type.downcase == 'hash'
      Hash
    elsif type.downcase == 'complex'
      Complex
    elsif type.downcase == 'rational'
      Rational
    elsif type.downcase == 'fixnum'
      Fixnum
    elsif type.downcase == 'falseclass'
      FalseClass
    elsif type.downcase == 'trueclass'
      TrueClass
    elsif type.downcase == 'bignum'
      Bignum
    else
    end
  end

end