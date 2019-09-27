module ClientApi

  def validate(options = {})
    raise_error('key (or) operator is not given!') if options[:key].nil? && options[:operator].nil?
    raise_error('value (or) type is not given!') if options[:value].nil? && options[:type].nil?

    key = options[:key]
    value = options[:value] if options[:value]
    operator = options[:operator]
    datatype = options[:type] if options[:type] || options[:type] != {} || !options[:type].empty?

    case operator
    when '==', 'eql?', 'equal', 'equal?'
      expect(body[key]).to eq(value)
    when '!=', '!eql?', 'not equal', '!equal?'
      expect(body[key]).not eq(value)
    else
      raise_error('operator not matching')
    end
  end

end