require "json-schema"

module ClientApi

  def validate(res, *options)
    options.map do |data|
      raise('"key": ""'.green + ' field is missing'.red) if data[:key].nil?
      raise('"operator":'.green + ' or'.red + ' "size":'.green + ' or'.red + ' "empty":'.green + ' "has_key":'.green + ' field is not given!'.red) if data[:operator].nil? && data[:size].nil? && data[:empty].nil? && data[:has_key].nil?
      raise('"value":'.green + ' or'.red + ' "size":'.green + ' or'.red + ' "type":'.green + ' field is not given!'.red) if data[:value].nil? && data[:type].nil? && data[:size].nil? if data[:operator] != nil

      value ||= data[:value]
      operator ||= data[:operator]
      type ||= data[:type]
      size ||= data[:size]
      empty ||= data[:empty]
      has_key ||= data[:has_key]

      @resp = JSON.parse(res.to_json)
      key = data[:key].split("->")

      key.map do |method|
        method = method.to_i if is_num?(method)
        begin
          @resp = @resp.send(:[], method)
        rescue NoMethodError
          raise "[key]: \"#{data[:key]}\"".blue + "\n does not exist"+"\n" if data[:has_key].nil?
        end
      end

      if operator != nil
        case operator
        when '=', '==', 'eql', 'eql?', 'equal', 'equal?'
          # value validation
          expect(value).to eq(@resp), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  didn't match \n[value]: \"#{data[:value]}\"\n"} if value != nil

          # datatype validation
          if (type == 'boolean') || (type == 'bool')
            expect(%w[TrueClass, FalseClass].any? {|bool| bool.include? @resp.class.to_s}).to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          elsif ((type != 'boolean') || (type != 'bool')) && (type != nil)
            expect(datatype(type, value)).to eq(@resp.class), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          end

          # size validation
          validate_size(size, data) if size != nil

          # is empty validation
          validate_empty(empty, data) if empty != nil

          # has key validation
          validate_key(has_key, data) if has_key != nil

        when '!', '!=', '!eql', '!eql?', 'not eql', 'not equal', '!equal?'
          # value validation
          expect(value).not_to eq(@resp), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  didn't match \n[value]: \"#{data[:value]}\"\n"} if value != nil

          # datatype validation
          if (type == 'boolean') || (type == 'bool')
            expect(%w[TrueClass, FalseClass].any? {|bool| bool.include? @resp.class.to_s}).not_to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          elsif ((type != 'boolean') || (type != 'bool')) && (type != nil)
            expect(datatype(type, value)).not_to eq(@resp.class), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          end

          # size validation
          if size != nil
            begin
              expect(size).not_to eq(@resp.count), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "size shouldn't match" + "\n\n" + "[   actual size   ]: #{@resp.count}" + "\n" + "[size not expected]: #{size}".green}
            rescue NoMethodError
              expect(size).not_to eq(0), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "size shouldn't match" + "\n\n" + "[   actual size   ]: 0" + "\n" + "[size not expected]: #{size}".green}
            rescue ArgumentError
              expect(size).not_to eq(0), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "size shouldn't match" + "\n\n" + "[   actual size   ]: 0" + "\n" + "[size not expected]: #{size}".green}
            end
          end

          # is empty validation
          validate_empty(empty, data) if empty != nil

          # has key validation
          validate_key(has_key, data) if has_key != nil

        when '>', '>=', '<', '<=', 'greater than', 'greater than or equal to', 'less than', 'less than or equal to', 'lesser than', 'lesser than or equal to'
          message = 'is not greater than (or) equal to' if operator == '>=' || operator == 'greater than or equal to'
          message = 'is not greater than' if operator == '>' || operator == 'greater than'
          message = 'is not lesser than (or) equal to' if operator == '<=' || operator == 'less than or equal to'
          message = 'is not lesser than' if operator == '<' || operator == 'less than' || operator == 'lesser than'

          # value validation
          expect(@resp.to_i.public_send(operator, value)).to eq(true), "[key]: \"#{data[:key]}\"".blue + "\n  #{message} \n[value]: \"#{data[:value]}\"\n" if value != nil

          # datatype validation
          expect(datatype(type, value)).to eq(@resp.class), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"} if type != nil

          # size validation
          if size != nil
            begin
              expect(@resp.count.to_i.public_send(operator, size)).to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "#{message} #{size}" + "\n\n" + "[ actual size ]: #{@resp.count}" + "\n" + "expected size to be #{operator} #{size}".green}
            rescue NoMethodError
              expect(0.public_send(operator, size)).to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "#{message} #{size}" + "\n\n" + "[ actual size ]: 0" + "\n" + "expected size to be #{operator} #{size}".green}
            rescue ArgumentError
              expect(0.public_send(operator, size)).to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "#{message} #{size}" + "\n\n" + "[ actual size ]: 0" + "\n" + "expected size to be #{operator} #{size}".green}
            end
          end

          # is empty validation
          validate_empty(empty, data) if empty != nil

          # has key validation
          validate_key(has_key, data) if has_key != nil

        when 'contains', 'has', 'contains?', 'has?', 'include', 'include?'
          # value validation
          expect(@resp.to_s).to include(value.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n  not contains \n[value]: \"#{data[:value]}\"\n"} if value != nil

          # datatype validation
          if (type == 'boolean') || (type == 'bool')
            expect(%w[TrueClass, FalseClass].any? {|bool| bool.include? @resp.class.to_s}).to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          elsif ((type != 'boolean') || (type != 'bool')) && (type != nil)
            expect(datatype(type, value)).to eq(@resp.class), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          end

          # size validation
          if size != nil
            begin
              expect(@resp.count.to_s).to include(size.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n"+ "size not contains #{size}"+ "\n\n" + "[ actual size ]: #{@resp.count}" + "\n" + "expected size to contain: #{size}".green}
            rescue NoMethodError
              expect(0.to_s).to include(size.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n"+ "size not contains #{size}"+ "\n\n" + "[ actual size ]: 0" + "\n" + "expected size to contain: #{size}".green}
            rescue ArgumentError
              expect(0.to_s).to include(size.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n"+ "size not contains #{size}"+ "\n\n" + "[ actual size ]: 0" + "\n" + "expected size to contain: #{size}".green}
            end
          end

          # is empty validation
          validate_empty(empty, data) if empty != nil

        when 'not contains', '!contains', 'not include', '!include'
          # value validation
          expect(@resp.to_s).not_to include(value.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n  should not contain \n[value]: \"#{data[:value]}\"\n"} if value != nil

          # datatype validation
          if (type == 'boolean') || (type == 'bool')
            expect(%w[TrueClass, FalseClass].any? {|bool| bool.include? @resp.class.to_s}).not_to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          elsif ((type != 'boolean') || (type != 'bool')) && (type != nil)
            expect(datatype(type, value)).not_to eq(@resp.class), lambda {"[key]: \"#{data[:key]}\"".blue + "\n  datatype shouldn't be \n[type]: \"#{data[:type]}\"\n"}
          end

          # size validation
          if size != nil
            begin
              expect(@resp.count.to_s).not_to include(size.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n"+ "size should not contain #{size}"+ "\n\n" + "[ actual size ]: #{@resp.count}" + "\n" + "expected size not to contain: #{size}".green}
            rescue NoMethodError
              expect(0.to_s).not_to include(size.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n"+ "size should not contain #{size}"+ "\n\n" + "[ actual size ]: 0" + "\n" + "expected size not to contain: #{size}".green}
            rescue ArgumentError
              expect(0.to_s).not_to include(size.to_s), lambda {"[key]: \"#{data[:key]} => #{@resp}\"".blue + "\n"+ "size should not contain #{size}"+ "\n\n" + "[ actual size ]: 0" + "\n" + "expected size not to contain: #{size}".green}
            end
          end

          # is empty validation
          validate_empty(empty, data) if empty != nil

          # has key validation
          validate_key(has_key, data) if has_key != nil

        else
          raise('operator not matching')
        end

      elsif ((size != nil) || (empty != nil) || (has_key != nil)) && operator.nil?
        validate_empty(empty, data) if empty != nil
        validate_size(size, data) if size != nil
        validate_key(has_key, data) if has_key != nil

      else
        raise('invalid validation fields')
      end
    end

  end

  def validate_size(size, data)
    begin
      expect(size).to eq(@resp.count), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "size didn't match" + "\n\n" + "[ actual size ]: #{@resp.count}" + "\n" + "[expected size]: #{size}".green}
    rescue NoMethodError
      expect(size).to eq(0), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "size didn't match" + "\n\n" + "[ actual size ]: 0" + "\n" + "[expected size]: #{size}".green}
    rescue ArgumentError
      expect(size).to eq(0), lambda {"[key]: \"#{data[:key]}\"".blue + "\n" + "size didn't match" + "\n\n" + "[ actual size ]: 0" + "\n" + "[expected size]: #{size}".green}
    end
  end

  def validate_empty(empty, data)
    case empty
    when true
      expect(@resp.nil?).to eq(empty), lambda {"[key]: \"#{data[:key]}\"".blue + "\n is not empty"+"\n"} if [Integer, TrueClass, FalseClass, Float].include? @resp.class
      expect(@resp.empty?).to eq(empty), lambda {"[key]: \"#{data[:key]}\"".blue + "\n is not empty"+"\n"} if [String, Hash, Array].include? @resp.class
    when false
      expect(@resp.nil?).to eq(empty), lambda {"[key]: \"#{data[:key]}\"".blue + "\n is empty"+"\n"} if [Integer, TrueClass, FalseClass, Float].include? @resp.class
      expect(@resp.empty?).to eq(empty), lambda {"[key]: \"#{data[:key]}\"".blue + "\n is empty"+"\n"} if [String, Hash, Array].include? @resp.class
    end
  end

  def validate_key(has_key, data)
    case has_key
    when true
      begin
        expect(@resp.nil?).to eq(false), lambda {"[key]: \"#{data[:key]}\"".blue + "\n does not exist"+"\n"}
      rescue NoMethodError
        raise "[key]: \"#{data[:key]}\"".blue + "\n does not exist"+"\n"
      end

    when false
      begin
        expect(@resp.nil?).to eq(true), lambda {"[key]: \"#{data[:key]}\"".blue + "\n does exist"+"\n"}
      rescue NoMethodError
        true
      end
    end
  end

  def validate_schema(param1, param2)
    expected_schema = JSON::Validator.validate(param1, param2)
    expect(expected_schema).to eq(true)
  end

  def validate_headers(res, *options)
    options.map do |data|
      raise('key is not given!') if data[:key].nil?
      raise('operator is not given!') if data[:operator].nil?
      raise('value is not given!') if data[:value].nil?

      @resp_header = JSON.parse(res.to_json)

      key = data[:key]
      value = data[:value]
      operator = data[:operator]

      case operator
      when '=', '==', 'eql?', 'equal', 'equal?'
        expect(value).to eq(@resp_header[key][0]), lambda {"\"#{key}\" => \"#{value}\"".blue + "\n  didn't match \n\"#{key}\" => \"#{@resp_header[key][0]}\"\n"}

      when '!', '!=', '!eql?', 'not equal', '!equal?'
        expect(value).not_to eq(@resp_header[key][0]), lambda {"\"#{key}\" => \"#{value}\"".blue + "\n  shouldn't match \n\"#{key}\" => \"#{@resp_header[key][0]}\"\n"}

      else
        raise('operator not matching')
      end
    end
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
    elsif (type.downcase == 'falseclass') || (type.downcase == 'false')
      FalseClass
    elsif (type.downcase == 'trueclass') || (type.downcase == 'true')
      TrueClass
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

    @actual_key, @actual_value = [], []
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
      @assert, @final_assert, @overall = [], [], []

      if !value.is_a?(Array)
        expect(value).to eq(@resp)
      else
        @resp.each_with_index do |resp, i|
          value.to_a.each_with_index do |val1, j|
            val1.to_a.each_with_index do |val2, k|
              if resp.to_a.include? val2
                @assert << true
              else
                @assert << false
              end
            end
            @final_assert << @assert
            @assert = []

            if @resp.count == @final_assert.count
              @final_assert.each_with_index do |result, i|
                if result.count(true) == val1.count
                  @overall << true
                  break
                elsif @final_assert.count == i+1
                  expect(value).to eq(@resp)
                end
              end
              @final_assert = []
            end

          end
        end

        if @overall.count(true) == value.count
        else
          expect(value).to eq(@resp)
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
              v = ""
            end
          end
          stack.push [key.dup << k, v]
        end
      end
    end
  end

end

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end