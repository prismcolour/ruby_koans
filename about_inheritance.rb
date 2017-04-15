require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutInheritance < Neo::Koan
  class Dog
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def bark
      "WOOF"
    end
  end

  class Chihuahua < Dog
    def wag
      :happy
    end

    def bark
      "yip"
    end
  end

  def test_subclasses_have_the_parent_as_an_ancestor
    assert_equal true, Chihuahua.ancestors.include?(Dog)
  end

  def test_all_classes_ultimately_inherit_from_object
    assert_equal true, Chihuahua.ancestors.include?(Object)
  end

  def test_subclasses_inherit_behavior_from_parent_class
    chico = Chihuahua.new("Chico")
    assert_equal "Chico", chico.name
  end

  def test_subclasses_add_new_behavior
    chico = Chihuahua.new("Chico")
    assert_equal :happy, chico.wag

    assert_raise(NoMethodError) do
      fido = Dog.new("Fido")
      fido.wag
    end
  end

  def test_subclasses_can_modify_existing_behavior
    chico = Chihuahua.new("Chico")
    assert_equal "yip", chico.bark

    fido = Dog.new("Fido")
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  # Super will allow inheritance from the top most hierarchy if there are 
  # two of the same methods 
  # def bark already in class Dog 
  # super keyword added to def bark in BullDog
  
  class BullDog < Dog
    def bark
      super + ", GROWL"
    end
  end

  def test_subclasses_can_invoke_parent_behavior_via_super
    ralph = BullDog.new("Ralph")
    assert_equal "WOOF, GROWL", ralph.bark
  end

  # ------------------------------------------------------------------

  class GreatDane < Dog
    def growl
      super.bark + ", GROWL"
    end
  end
  
  # Super does not work in the above growl method definition
  # Super is similar to a yield
  # It pulls in the functionality of the top hierarchy of the class it's
  # inheriting from
  # Hence class error NoMethodError when doing an assert_raise
  # super refers to pulling in the bark functionality from class Dog
  # super.bark doesn't exist and cannot be used this way
  
  def test_super_does_not_work_cross_method
    george = GreatDane.new("George")
    assert_raise(NoMethodError) do
      george.growl
    end
  end

end
