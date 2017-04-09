require File.expand_path(File.dirname(__FILE__) + '/neo')

def my_global_method(a,b)
  a + b
end

class AboutMethods < Neo::Koan

  def test_calling_global_methods
    assert_equal 5, my_global_method(2,3)
  end

  def test_calling_global_methods_without_parentheses
    result = my_global_method 2, 3
    assert_equal 5, result
  end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  def test_sometimes_missing_parentheses_are_ambiguous
    eval "assert_equal 5, my_global_method(2, 3)" # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end

  # NOTE: wrong number of arguments is not a SYNTAX error, but a
  # runtime error.
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      my_global_method
    end
    assert_match(/wrong number of arguments/, exception.message)

    exception = assert_raise(ArgumentError) do
      my_global_method(1,2,3)
    end
    assert_match(/wrong number of arguments/, exception.message)
  end

  # ------------------------------------------------------------------

  def method_with_defaults(a, b=:default_value)
    [a, b]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  def method_with_var_args(*args)
    args
  end

  def test_calling_with_variable_arguments
    
    # http://ploos.io/ruby-koans-companion-part-10-about_methods-rb/
    # * splat operator for multiple arguments within 1 parameter
    # Arguments get put into an array
    # When zero arguments, returns an empty array
    
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal [:one, :two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  def method_with_explicit_return
    :a_non_return_value
    return :return_value
    :another_non_return_value
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end

  def test_method_without_explicit_return
    # When we don't explicitly return, 
    # we just get the very last thing we evaluated.
    
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------

  def my_method_in_the_same_class(a, b)
    # Non-explicit return value
    
    a * b
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3,4)
  end

  def test_calling_methods_in_same_class_with_explicit_receiver
    # Explicit receivers applicable to situations with variable scope
    
    assert_equal 12, self.my_method_in_the_same_class(3,4)
  end

  # ------------------------------------------------------------------

  def my_private_method
    "a secret"
  end
  private :my_private_method

  def test_calling_private_methods_without_receiver
    assert_equal "a secret", my_private_method
  end

  def test_calling_private_methods_with_an_explicit_receiver
    exception = assert_raise(Exception) do
      self.my_private_method
    end
    assert_match /private method/, exception.message
  end

  # ------------------------------------------------------------------

  class Dog
    def name
      "Fido"
    end

    private

    def tail
      "tail"
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal "Fido", rover.name
  end

  def test_calling_private_methods_in_other_objects
    
    # http://stackoverflow.com/questions/4293215/
    # understanding-private-methods-in-ruby
    # will not work, because we specified explicit receiver - 
    # instance of Example (e), and that is against a "private rule".
    # What private means in Ruby is a method cannot 
    # be called with a explicit receivers, 
    # e.g. some_instance.private_method(value)
    
    # Workaround: 
    # Is there a way to call a private Class method 
    # from an instance in Ruby?
    # http://stackoverflow.com/questions/20674/is-there-a-way-to-
    # call-a-private-class-method-from-an-instance-in-ruby
    # http://stackoverflow.com/questions/39344445/
    # private-methods-calling-in-ruby
    # Ex. p = Private.new
    # p.instance_eval{ private_method("private method called") }
    # p is an implicit receiver
    
    # Difference between implicit receivers and explicit receivers 
    # https://www.reddit.com/r/ruby/comments/436d1m/
    # what_is_the_difference_between_an_implicit_and/
    # "Every method you call is received by some object. The object receiving the method call is the receiver. If you mention 
    # the object in the call, that's 'explicit'. 
    # If you call a method in the same object as the 
    # context without mentioning 'self', that's 'implicit'."

    rover = Dog.new
    assert_raise(Exception) do
      rover.tail
    end
  end
end
