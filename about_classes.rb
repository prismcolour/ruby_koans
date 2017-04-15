require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClasses < Neo::Koan
  class Dog
  end

  def test_instances_of_classes_can_be_created_with_new
    fido = Dog.new
    assert_equal Dog, fido.class
  end

  # ------------------------------------------------------------------

  class Dog2
    # Setting instance variables
    def set_name(a_name)
      @name = a_name
    end
  end

  def test_instance_variables_can_be_set_by_assigning_to_them
    fido = Dog2.new
    assert_equal [], fido.instance_variables
     
    # To get properties on a class
    # .instance_variables method
    # Instance variables get put into an array 
    # The object fido has attributes via instance variables set using 
    # the setter method 
    
    fido.set_name("Fido")
    assert_equal [:@name], fido.instance_variables
  end

  def test_instance_variables_cannot_be_accessed_outside_the_class
    fido = Dog2.new
    fido.set_name("Fido")

  # Error class NoMethodError
  # Raise error for NoMethodError
    assert_raise(NoMethodError) do
      fido.name
    end
  
  # Raise error for error class SyntaxError
    assert_raise(SyntaxError) do
      eval "fido.@name"
      # NOTE: Using eval because the above line is a syntax error.
    end
  end

  def test_you_can_politely_ask_for_instance_variable_values
    fido = Dog2.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.instance_variable_get("@name")
  end

  def test_you_can_rip_the_value_out_using_instance_eval
    fido = Dog2.new
    fido.set_name("Fido")

  # One is getting fed in as an argument
  # Secone one has a yield block in the method call
    assert_equal "Fido", fido.instance_eval("@name")  # string version
    assert_equal "Fido", fido.instance_eval { @name } # block version
  end

  # ------------------------------------------------------------------

  class Dog3
    def set_name(a_name)
      @name = a_name
    end
    def name
      @name
    end
  end

  # Whenever you see .property that is an accessor method
  # Not the same as bringing back an array of instance variables
  # via .instance_variables, .instance_variables_get brings back the object 
  # in the actual array, .instance_eval does the same thing except you can use 
  # () or a block 
  def test_you_can_create_accessor_methods_to_return_instance_variables
    fido = Dog3.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog4
    # attr_reader :name
    # SHORTHAND:
    # def name
    #  @name
    # end 
    
    # .name
    # Gives you .name accessor - can use the .name method to access attribute
    # Accessors access properties
    # attr_reader allows you to read back the value when accessing the property
    # via . notation
    # You just need to write a setter
    
    attr_reader :name

    def set_name(a_name)
      @name = a_name
    end
  end


  def test_attr_reader_will_automatically_define_an_accessor
    fido = Dog4.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------
  # Shortcut for setter/getter
  # Accessor for .name 
  # You can just set the attribute via .name instead of calling a setter method
  # that you had to previously write .set_name("Fido")
  # shorthand would be fido.name = "Fido" 
  # Using the accessor to set the property instead
  
  class Dog5
    attr_accessor :name
  end


  def test_attr_accessor_will_automatically_define_both_read_and_write_accessors
    fido = Dog5.new

    fido.name = "Fido"
    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog6
    attr_reader :name
    def initialize(initial_name)
      @name = initial_name
    end
  end
  
  # Write an initialize method for the object so you can set initial values
  # when creating objects using .new

  def test_initialize_provides_initial_values_for_instance_variables
    fido = Dog6.new("Fido")
    assert_equal "Fido", fido.name
  end

  # Number of arguments must match number of initial parameters 
  # to be initialized 
  # Raise ArgumentError due to wrong number of arguments
  def test_args_to_new_must_match_initialize
    assert_raise(ArgumentError) do
      Dog6.new
    end
    # THINK ABOUT IT:
    # Why is this so?
    # Number of arguments going into a method always needs to match the 
    # number of parameters the method is expected to receive 
  end

  def test_different_objects_have_different_instance_variables
    fido = Dog6.new("Fido")
    rover = Dog6.new("Rover")

    assert_equal true, rover.name != fido.name
  end

  # ------------------------------------------------------------------

  class Dog7
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name
    end
    
    # Self refers to the containing object
    def get_self
      self
    end

    def to_s
      @name
    end

    def inspect
      "<Dog named '#{name}'>"
    end
  end

  def test_inside_a_method_self_refers_to_the_containing_object
    fido = Dog7.new("Fido")
    
    # self is a keyword to get containing object
    # fido is the object
    
    fidos_self = fido.get_self
    assert_equal fido, fidos_self
  end

  def test_to_s_provides_a_string_version_of_the_object
    fido = Dog7.new("Fido")
    assert_equal "Fido", fido.to_s
  end

  # Did not understand this
  # http://stackoverflow.com/questions/31521756/
  # what-does-it-mean-to-use-the-name-of-a-class-for-string-interpolation
  # fido is not a string object so how is that being interpolated as a string?
  # According to stackoverflow, implicit call to .to_s to get @name 
  # That gets fed into #{@name} to get Fido.
  
  def test_to_s_is_used_in_string_interpolation
    fido = Dog7.new("Fido")
    assert_equal "My dog is Fido", "My dog is #{fido}"
  end

  def test_inspect_provides_a_more_complete_string_version
    fido = Dog7.new("Fido")
    assert_equal "<Dog named 'Fido'>", fido.inspect
  end

  def test_all_objects_support_to_s_and_inspect
    array = [1,2,3]

    # Tricky for array.to_s 
    # Converts to string as characters not individual elements 
    assert_equal "[1, 2, 3]", array.to_s
    assert_equal "[1, 2, 3]", array.inspect
    
    # Tricky for something in quotation marks already 
    # .inspect will return the "" double quotes as chars
    # Will return the escape character for double quotes
    # Backslash saves lives
    assert_equal "STRING", "STRING".to_s
    assert_equal "\"STRING\"", "STRING".inspect
  end

end
