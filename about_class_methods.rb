require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClassMethods < Neo::Koan
  class Dog
  end

  def test_objects_are_objects
    fido = Dog.new
    assert_equal true, fido.is_a?(Object)
  end

  def test_classes_are_classes
    assert_equal true, Dog.is_a?(Class)
  end

  def test_classes_are_objects_too
    assert_equal true, Dog.is_a?(Object)
  end

  def test_objects_have_methods
    fido = Dog.new
    assert fido.methods.size > 0
  end

  def test_classes_have_methods
    assert Dog.methods.size > 0
  end

  # Adding methods to an instanced object
  # singleton_method 
  # obj.define_singleton_method(:new_method) 
  # https://ruby-doc.org/core-2.2.3/
  # Object.html#method-i-singleton_method
  # CLEARER notation to define methods for instance objects 
  # via singleton_method 
  # instance.singleton_method(:method_name)
  # Ex. k.singleton_method(:hi)
  # def k.hi 
  # This will be clearer code so it's immediately known that this method
  # does not belong to a class and belongs to an instance object
  
  
  def test_you_can_define_methods_on_individual_objects
    fido = Dog.new
    def fido.wag
      :fidos_wag
    end
    assert_equal :fidos_wag, fido.wag
  end

  def test_other_objects_are_not_affected_by_these_singleton_methods
    fido = Dog.new
    rover = Dog.new
    def fido.wag
      :fidos_wag
    end

    assert_raise(NoMethodError) do
      rover.wag
    end
  end

  # ------------------------------------------------------------------

  #Singleton_methods as applied to Class objects
  class Dog2
    def wag
      :instance_level_wag
    end
  end

  def Dog2.wag
    :class_level_wag
  end

  def test_since_classes_are_objects_you_can_define_singleton_methods_on_them_too
    assert_equal :class_level_wag, Dog2.wag
  end

  def test_class_methods_are_independent_of_instance_methods
    fido = Dog2.new
    # fido is an instance object 
    # .wag method from class applied to fido 
    assert_equal :instance_level_wag, fido.wag
    
    # class object 
    # singleton_method applied to Class object
    # Dog2.wag
    assert_equal :class_level_wag, Dog2.wag
    
  end

  # ------------------------------------------------------------------

  class Dog
    attr_accessor :name
  end

  def Dog.name
    @name
  end
  
  # Classes are separate objects from instance variables 
  # and instance objects
  def test_classes_and_instances_do_not_share_instance_variables
    fido = Dog.new
    fido.name = "Fido"
    assert_equal "Fido", fido.name
    assert_equal nil, Dog.name
  end

  # ------------------------------------------------------------------

  class Dog
    def Dog.a_class_method
      :dogs_class_method
    end
  end

  # This way writing the method allows you not to instantiate an object 
  # Calling the method on a class instead of on an instance object
  # http://stackoverflow.com/questions/336024/
  # calling-a-class-method-within-a-class
  
  # Prefixing the Class Name ahead of the method name will create
  # a class method within the class and not an instance method
  
  # Calling the class method will be Dog.a_class_method

  def test_you_can_define_class_methods_inside_the_class
    assert_equal :dogs_class_method, Dog.a_class_method
  end

  # ------------------------------------------------------------------

  LastExpressionInClassStatement = class Dog
                                     21
                                   end
  # Even if the class is empty
  # Implicit return in class/end block
  
  def test_class_statements_return_the_value_of_their_last_expression
    assert_equal 21, LastExpressionInClassStatement
  end

  # ------------------------------------------------------------------

  SelfInsideOfClassStatement = class Dog
                                 self
                               end

  def test_self_while_inside_class_is_class_object_not_instance
    assert_equal true, Dog == SelfInsideOfClassStatement
  end

  # ------------------------------------------------------------------
  
  # Use self keyword when writing class methods inside a class 
  # Keep it DRY
  # self keyword is an explicit REFERENCE
  
  class Dog
    def self.class_method2
      :another_way_to_write_class_methods
    end
  end

  def test_you_can_use_self_instead_of_an_explicit_reference_to_dog
    assert_equal :another_way_to_write_class_methods, Dog.class_method2
  end

  # ------------------------------------------------------------------

  # http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby
  # class << self idiom 
  # Opens up singleton_methods for classes 
  # This is a way to organize code when writing class methods within 
  # a class
  
  # Better explaination found here:
  # http://stackoverflow.com/questions/1630815/
  # why-isnt-the-eigenclass-equivalent-to-self-
  # class-when-it-looks-so-similar
  
  class Dog
    class << self
      def another_class_method
        :still_another_way
      end
    end
  end

  def test_heres_still_another_way_to_write_class_methods
    assert_equal :still_another_way, Dog.another_class_method
  end

  # THINK ABOUT IT:
  #
  # The two major ways to write class methods are:
  #   class Demo
  #     def self.method
  #     end
  #
  #     class << self
  #       def class_methods
  #       end
  #     end
  #   end
  #
  # Which do you prefer and why?
  # Are there times you might prefer one over the other?
  # class << self is a clearer way to make it known that the following 
  # code will be singleton_methods for a class 
  # The other way to write class methods within a class is repetitive 
  # via the self keyword 
  # class << self keeps the code DRY 
  # class << self opens up the singleton class/eigenclass
  
  # The eigenclass is also called the singleton class or 
  # (less commonly) the metaclass. The term “eigenclass” 
  # is not uniformly accepted within the Ruby community, 
  # but it is the term we'll use in this book. Ruby defines a 
  # syntax for opening the eigenclass of an object and 
  # adding methods to it.  SYNTAX: class << self
  # https://www.safaribooksonline.com/library/view/the-ruby-
  # programming/.../ch07s07.html
  # ------------------------------------------------------------------
  
  # If you wanted to use the functionality of a class method on an 
  # instance, daisy chain by calling the .class method on the instance
  # to access the class method within the class
  
  def test_heres_an_easy_way_to_call_class_methods_from_instance_methods
    fido = Dog.new
    assert_equal :still_another_way, fido.class.another_class_method
  end

end
