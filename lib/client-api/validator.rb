module ClientApi

  def validate(*options)
    options.map do |data|
      raise_error('key (or) operator is not given!') if data[:key].nil? && data[:operator].nil?
      raise_error('value (or) type is not given!') if data[:value].nil? && data[:type].nil?

      key = data[:key]
      value = data[:value] if data[:value]
      operator = data[:operator]
      type = data[:type] if data[:type] || data[:type] != {} || !data[:type].empty?

      case operator
      when '=', '==', 'eql?', 'equal', 'equal?'
        expect(body[key]).to eq(value) if value
        expect(body[key].class).to eq(datatype(type)) if type
      when '!', '!=', '!eql?', 'not equal', '!equal?'
        expect(body[key]).not_to eq(value) if value
        expect(body[key].class).not_to eq(datatype(type)) if type
      else
        raise_error('operator not matching')
      end
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