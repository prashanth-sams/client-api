require "json-schema"

module ClientApi

  def validate(*options)
    options.map do |data|
      raise_error('key (or) operator is not given!') if data[:key].nil? && data[:operator].nil?
      raise_error('value (or) type is not given!') if data[:value].nil? && data[:type].nil?

      @resp = resp
      key = data[:key].split("->")

      key.map do |method|
        method = method.to_i if is_num?(method)
        @resp = @resp.send(:[], method)
      end

      value ||= data[:value]
      operator = data[:operator]
      type = data[:type] if data[:type] || data[:type] != {} || !data[:type].empty?

      case operator
      when '=', '==', 'eql?', 'equal', 'equal?'
        # value validation
        expect(@resp).to eq(value) if value != nil

        # datatype validation
        if (type == "boolean" || type == "bool") && value.nil?
          expect(%w[TrueClass, FalseClass].any? {|bool| @resp.class.to_s.include? bool}).to be true
        else
          expect(@resp.class).to eq(datatype(type, value))
        end

      when '!', '!=', '!eql?', 'not equal', '!equal?'
        # value validation
        expect(@resp).not_to eq(value) if value != nil

        # datatype validation
        if (type == "boolean" || type == "bool") && value.nil?
          expect(%w[TrueClass, FalseClass].any? {|bool| @resp.class.to_s.include? bool}).not_to be true
        else
          expect(@resp.class).not_to eq(datatype(type, value))
        end
      else
        raise_error('operator not matching')
      end
    end
  end

  def validate_schema(param1, param2)
    expected_schema = JSON::Validator.validate(param1, param2)
    expect(expected_schema).to be true
  end

  def datatype(type, value)
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
    elsif (type.downcase == 'boolean') || (type.downcase == 'bool')
      value === true ? TrueClass : FalseClass
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

  def is_num?(str)
    if Float(str)
      true
    end
  rescue ArgumentError, TypeError
    false
  end

  def validate_json(actual, expected)
    param1 = JSON.parse(actual.to_json)
    param2 = JSON.parse(expected.to_json)

    @actual_key = []
    @actual_value = []
    deep_traverse(param2) do |path, value|
      if !value.is_a?(Hash)
        key_path = path.map! {|k| k}
        @actual_key << key_path.join("->").to_s
        @actual_value << value
      end
    end

    Hash[@actual_key.zip(@actual_value)].map do |data|
      @resp = param1
      key = data[0].split("->")

      key.map do |method|
        method = method.to_i if is_num?(method)
        @resp = @resp.send(:[], method)
      end

      value = data[1]
      @assert = []

      if !value.is_a?(Array)
        expect(@resp).to eq(value)
      else
        @resp.each_with_index do |resp, i|
          value[0].to_a.each_with_index do |val, j|
            if resp.to_a.include? val
              expect(resp.to_a.include? val).to be true
              @assert << true
              return if @assert.count(true) == value[0].to_a.count && value[0].to_a.count == j + 1
            else
              @assert << false
            end
          end
          expect(@resp).to eq(value) if @resp.count == i + 1
        end
      end
    end
  end

  def deep_traverse(hash, &block)
    stack = hash.map {|k, v| [[k], v]}

    while not stack.empty?
      key, value = stack.pop
      yield(key, value)
      if value.is_a? Hash
        value.each do |k, v|
          if v.is_a?(String) then
            if v.empty? then
              v = nil
            end
          end
          stack.push [key.dup << k, v]
        end
      end
    end
  end

end