require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutSymbols < Neo::Koan
  def test_symbols_are_symbols
    symbol = :ruby
    assert_equal true, symbol.is_a?(Symbol)
  end

  def test_symbols_can_be_compared
    symbol1 = :a_symbol
    symbol2 = :a_symbol
    symbol3 = :something_else

    assert_equal true, symbol1 == symbol2
    assert_equal false, symbol1 == symbol3
  end

  def test_identical_symbols_are_a_single_internal_object
    symbol1 = :a_symbol
    symbol2 = :a_symbol

    # TRICKY - symbol1.object_id == symbol2.object_id 
    # Same memory address 
    # Comparing identifier and not what is actually stored 
    # at the memory address
    
    assert_equal true, symbol1 == symbol2
    assert_equal true, symbol1.object_id == symbol2.object_id
  end

  def test_method_names_become_symbols
    symbols_as_strings = Symbol.all_symbols.map { |x| x.to_s }
    assert_equal true, symbols_as_strings.include?("test_method_names_become_symbols")
  end

  # THINK ABOUT IT:
  #
  # Why do we convert the list of symbols to strings and then compare
  # against the string value rather than against symbols?
  # Did not understand this
  # In Ruby, you can convert strings to symbols and symbols back to strings
  # Symbol.all_symbols is called to get a list of all known symbols 
  # and :nonexistent is in the list.
  # .to_sym convert to symbol
  # .to_s 
  # Symbol.all_symbols.collect{|x| x.to_s}.grep/"input regular expression"/
  
  # Answer from http://stackoverflow.com/questions/4686097/
  # ruby-koans-why-convert-list-of-symbols-to-strings
  # Better explaination here ~ http://ploos.io/ruby-koans-companion-
  # part-8-about_symbols-rb/
  # Purpose of this koan is to show that you can turn strings into symbols 


  in_ruby_version("mri") do
    RubyConstant = "What is the sound of one hand clapping?"
    def test_constants_become_symbols
      all_symbols_as_strings = Symbol.all_symbols.map { |x| x.to_s }

      assert_equal false, all_symbols_as_strings.include?(:RubyConstant)
    end
  end

  def test_symbols_can_be_made_from_strings
    string = "catsAndDogs"
    assert_equal :catsAndDogs, string.to_sym
  end

  def test_symbols_with_spaces_can_be_built
    symbol = :"cats and dogs"

    assert_equal :"cats and dogs".to_sym, symbol
    
    # Turn the entire thing into a symbol
    # "Lord of the rings".to_sym
    # => :"Lord of the rings":"Lord of the rings"
  end

  def test_symbols_with_interpolation_can_be_built
    value = "and"
    symbol = :"cats #{value} dogs"

    assert_equal :"cats and dogs".to_sym, symbol
  end

  def test_to_s_is_called_on_interpolated_symbols
    symbol = :cats
    string = "It is raining #{symbol} and dogs."

    assert_equal "It is raining cats and dogs.", string
    
    # .to_s is called on interpolated symbols
  end

  def test_symbols_are_not_strings
    symbol = :ruby
    assert_equal false, symbol.is_a?(String)
    assert_equal false, symbol.eql?("ruby")
    
    # Symbol is an identifier
    # Alternatively, you can consider the colon to mean 
    # " thing named" so :id is "the thing named id." 
    # You can also think of :id as meaning the name of the variable id, 
    # and plain id as meaning the value of the variable. (value vs. name id)
    # A Symbol is the most basic Ruby object you can create.
    # http://rubylearning.com/satishtalim/ruby_symbols.html
  end

  def test_symbols_do_not_have_string_methods
    symbol = :not_a_string
    assert_equal false, symbol.respond_to?(:each_char)
    assert_equal false, symbol.respond_to?(:reverse)
  end

  # It's important to realize that symbols are not "immutable
  # strings", though they are immutable. None of the
  # interesting string operations are available on symbols.

  def test_symbols_cannot_be_concatenated
    # Exceptions will be pondered further down the path
    assert_raise(Exception) do
      :cats + :dogs
    end
  end

  def test_symbols_can_be_dynamically_created
    assert_equal :catsdogs, ("cats" + "dogs").to_sym
  end

  # THINK ABOUT IT:
  #
  # Why is it not a good idea to dynamically create a lot of symbols?
end
