require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutScope < Neo::Koan
  module Jims
    class Dog
      def identify
        :jims_dog
      end
    end
  end

  module Joes
    class Dog
      def identify
        :joes_dog
      end
    end
  end

  def test_dog_is_not_available_in_the_current_scope
    assert_raise(NameError) do
      Dog.new
    end
  end
  
  def test_you_can_reference_nested_classes_using_the_scope_operator
    fido = Jims::Dog.new
    rover = Joes::Dog.new
    assert_equal :jims_dog, fido.identify
    assert_equal :joes_dog, rover.identify

    assert_equal true, fido.class != rover.class
    assert_equal true, Jims::Dog != Joes::Dog
  end

  # ------------------------------------------------------------------

  class String
  end
   
  # This works because String is currently namespaced within the
  # AboutScope class but nested classes don't actually exist in Ruby
  # The scope operator allows you to use the functionality of having 
  # a nested class via routing the path to the GLOBAL SCOPE 
  # In Ruby the only way to get nested class functionality is through
  # inheritance via modules 
  # include module keyword to get added functionality 
  # :: This explicitly refers to the Class in the global scope
  # Whatever is before :: is the GLOBAL SCOPE
  
  # Global scope will return the current scope 
  # Access to current scope
  def test_bare_bones_class_names_assume_the_current_scope
    assert_equal true, AboutScope::String == String
  end
  
  # No nested classes in Ruby 
  # Need to force with scope operator :: to make this true
  # See next example
  def test_nested_string_is_not_the_same_as_the_system_string
    assert_equal false, String == "HI".class
  end

  # C = A::B
  # :: syntax will access the global scope 
  # Same as writing AboutScope::String
  def test_use_the_prefix_scope_operator_to_force_the_global_scope
    assert_equal true, ::String == "HI".class
  end

  # ------------------------------------------------------------------

  PI = 3.1416

  def test_constants_are_defined_with_an_initial_uppercase_letter
    assert_equal 3.1416, PI
  end

  # ------------------------------------------------------------------
  # http://www.linuxtopia.org/online_books/programming_books/ruby_tutorial
  # /Ruby_Classes_and_Objects_Class_Names_Are_Constants.html
  # All the built-in classes, along with the classes you define, have a 
  # corresponding global constant with the same name as the class. 

  MyString = ::String
  
  # MyString is a constant
  # All constants in Ruby start with a capital 
  # Class names are constants 
  # ::String is a global constant 
  # This is how MyString == ::String
  # In each class, there is a corresponding constant that is the same
  # as the class name
  
  def test_class_names_are_just_constants
    # This is not the object ::String 
    # This is just the constant 
    # The subtley is this that each class has a name and an object of
    # the same name
    # One is a REFERENCE and the other is the actual object 
    # This is just how Ruby is setup
    
    assert_equal true, MyString == ::String
    assert_equal true, MyString == "HI".class
  end

  # const_get(sym, inherit=true) → obj
  # https://ruby-doc.org/core-1.9.3/Module.html
  # If constant doesn't exist, assert_raise(NameError)
  
  def test_constants_can_be_looked_up_explicitly
    assert_equal true, PI == AboutScope.const_get("PI")
    assert_equal true, MyString == AboutScope.const_get("MyString")
  end

  def test_you_can_get_a_list_of_constants_for_any_class_or_module
    # Class name within the Module is Dog
    # Dog is the constant 
    # Constants method will return an array with the list of all 
    # constants within the class
    # Module.constants 
    # Jim is inheriting from the module class
    # Within the Module class
    # Method definition is using : symbol notation
    # define_method :constants_of_module, Module.instance_method(:constants)
    # http://stackoverflow.com/questions/2309255/
    # how-do-i-get-constants-defined-by-rubys-module-class-via-reflection
    # Constants of a module are defined as :constants
    
    assert_equal [:Dog], Jims.constants
    assert Object.constants.size > 0
  end
end

