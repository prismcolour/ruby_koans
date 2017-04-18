require File.expand_path(File.dirname(__FILE__) + '/neo')

# http://rubylearning.com/blog/2010/11/03/
# do-you-understand-rubys-objects-messages-and-blocks/

# Syntax
# :message
# [payloads1, ...payloadsN]
# optional paylods - payloads are arguments/parameters
# paylods are essentially a list of other objects
# Start thinking of Ruby as a message oriented object

class AboutMessagePassing < Neo::Koan

  class MessageCatcher
    def caught?
      true
    end
  end

  def test_methods_can_be_called_directly
    mc = MessageCatcher.new

    assert mc.caught?
  end

  def test_methods_can_be_invoked_by_sending_the_message
    mc = MessageCatcher.new

    assert mc.send(:caught?)
  end

  def test_methods_can_be_invoked_more_dynamically
    mc = MessageCatcher.new
    
    # ILLUSTRATION OF MESSAGE-OBJECT PROTOCOL IN RUBY
    # via .send() which is the same as . DOT notation
    # Method name is sent in as a string 
    # Methods need to be in '' when being sent as a parameter or as 
    # a message :
    # Otherwise assert_raise NoMethodName error
    # "caught?" same as :caught? 
    # http://stackoverflow.com/questions/3337285/what-does-send-do-in-ruby
    # hello method 
    # k.send :hello, "gentle", "readers"   #=> "Hello gentle readers"
    # send(:hello) same as sending the message send :hello 
    # send(:hello) is same as .hello 
    # .hello 
    # DOT NOTATION: 
    # 1.send '+', 2
    # 1.+(2)
    # 1 + 2
    
    assert mc.send("caught?")
    assert mc.send("caught" + "?" )    # What do you need to add to the first string?
    assert mc.send("CAUGHT?".downcase )      # What would you need to do to the string?
  end

  def test_send_with_underscores_will_also_send_messages
    mc = MessageCatcher.new

    assert_equal true, mc.__send__(:caught?)

    # THINK ABOUT IT:
    #
    # Why does Ruby provide both send and __send__ ?
    # http://stackoverflow.com/questions/4658269/ruby-send-vs-send
    # If you want to work with objects of any class 
    # you need to use __send__ to be on the safe side.
    # .__send__() uses Object#send and not the individual class send method
    # Used across objects to send a message 
    
  end

  def test_classes_can_be_asked_if_they_know_how_to_respond
    mc = MessageCatcher.new

    assert_equal true, mc.respond_to?(:caught?)
    assert_equal false, mc.respond_to?(:does_not_exist)
  end

  # ------------------------------------------------------------------

  class MessageCatcher
    def add_a_payload(*args)
      args
    end
  end

  def test_sending_a_message_with_arguments
    mc = MessageCatcher.new
    
    # mc.add_a_payload
    # .send(:add_a_payload) 
    # Both are the same 
    # Returns an array for parameter/argument list 
    
    assert_equal [], mc.add_a_payload
    assert_equal [], mc.send(:add_a_payload)

    assert_equal [3, 4, nil, 6], mc.add_a_payload(3, 4, nil, 6)
    assert_equal [3, 4, nil, 6], mc.send(:add_a_payload, 3, 4, nil, 6)
  end

  # NOTE:
  # Why use DOT notation vs .send(:messsage) - .send(:message) allows
  # for dynamic messages vs DOT notation is static, you already know which
  # method you're going to call but usually .DOT notation is used 
  # You still need to know message-object protocol in Ruby - this is
  # what is under the hood
  
  # Both obj.msg and obj.send(:msg) sends the message named :msg to
  # the object. We use "send" when the name of the message can vary
  # dynamically (e.g. calculated at run time), but by far the most
  # common way of sending a message is just to say: obj.msg.

  # ------------------------------------------------------------------

  class TypicalObject
  end

  def test_sending_undefined_messages_to_a_typical_object_results_in_errors
    typical = TypicalObject.new

    exception = assert_raise(NoMethodError) do
      typical.foobar
    end
    assert_match(/foobar/, exception.message)
  end

  def test_calling_method_missing_causes_the_no_method_error
    typical = TypicalObject.new
    # .method_missing is a Ruby method 
    # https://kconrails.com/2010/12/21/dynamic-methods-
    # in-ruby-with-method_missing/ 
    # Ruby is dynamic is that you can choose 
    # how to handle methods that are called, but don’t actually exist
    # You can override in the classes where you need more 
    # dynamic method calling
    
    exception = assert_raise(NoMethodError) do
      typical.method_missing(:foobar)
    end
    assert_match(/foobar/, exception.message)
    
    # https://codequizzes.wordpress.com/2014/04/24/rubys-method_missing/
    # More info here
    

    # THINK ABOUT IT:
    #
    # If the method :method_missing causes the NoMethodError, then
    # what would happen if we redefine method_missing?
    
    # Allows for custom error handling when method does not exist 
    # NoMethodError is the default error handling 
    # generic: # NoMethodError: undefined method `hello'
    # vs custom definition
    # def method_missing 'custom message' end 
    # method_missing is a Ruby method - from the module Kernel which is
    # mixed into Object class 
    # All Ruby objects inherit from the Object class
    #
    # NOTE:
    #
    # In Ruby 1.8 the method_missing method is public and can be
    # called as shown above. However, in Ruby 1.9 (and later versions)
    # the method_missing method is private. We explicitly made it
    # public in the testing framework so this example works in both
    # versions of Ruby. Just keep in mind you can't call
    # method_missing like that after Ruby 1.9 normally.
    #
    # Thanks.  We now return you to your regularly scheduled Ruby
    # Koans.
  end

  # ------------------------------------------------------------------

  class AllMessageCatcher
    def method_missing(method_name, *args, &block)
      "Someone called #{method_name} with <#{args.join(", ")}>"
    end
  end

  def test_all_messages_are_caught
    catcher = AllMessageCatcher.new
    
    # Custom error message handling for NoMethodError
    # foobar does not exist
    
    assert_equal "Someone called foobar with <>", catcher.foobar
    assert_equal "Someone called foobaz with <1>", catcher.foobaz(1)
    assert_equal "Someone called sum with <1, 2, 3, 4, 5, 6>", catcher.sum(1,2,3,4,5,6)
  end

  def test_catching_messages_makes_respond_to_lie
    catcher = AllMessageCatcher.new

    assert_nothing_raised do
      catcher.any_method
    end
    assert_equal false, catcher.respond_to?(:any_method)
  end

  # ------------------------------------------------------------------

  class WellBehavedFooCatcher
    def method_missing(method_name, *args, &block)
      if method_name.to_s[0,3] == "foo"
        "Foo to you too"
      else
        super(method_name, *args, &block)
      end
    end
  end
  
  # Writing in control flow into method_missing to differentiate which
  # error messages will be returned depending on which nonexistent method is
  # called
  
  def test_foo_method_are_caught
    catcher = WellBehavedFooCatcher.new

    assert_equal "Foo to you too", catcher.foo_bar
    assert_equal "Foo to you too", catcher.foo_baz
  end

  def test_non_foo_messages_are_treated_normally
    catcher = WellBehavedFooCatcher.new

   # Only 2 cases in the previous control flow 
   # All other cases will default to NoMethodError
   
    assert_raise(NoMethodError) do
      catcher.normal_undefined_method
    end
  end

  # ------------------------------------------------------------------

  # (note: just reopening class from above)
  class WellBehavedFooCatcher
    def respond_to?(method_name)
      if method_name.to_s[0,3] == "foo"
        true
      else
        super(method_name)
      end
    end
  end

  def test_explicitly_implementing_respond_to_lets_objects_tell_the_truth
    catcher = WellBehavedFooCatcher.new

    assert_equal true, catcher.respond_to?(:foo_bar)
    assert_equal false, catcher.respond_to?(:something_else)
  end

end
