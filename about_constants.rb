require File.expand_path(File.dirname(__FILE__) + '/neo')

C = "top level"

class AboutConstants < Neo::Koan

  C = "nested" 
  # A constant doesn’t require any special symbol or syntax to declare. 
  # You just need to make the first letter an uppercase letter.
  # you can’t define constants inside a method.
  # https://www.rubyguides.com/2017/07/ruby-constants/

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    ##assert_equal __, C
    assert_equal "nested", C #can access constant C outside of method, but still inside class
  end

  def test_top_level_constants_are_referenced_by_double_colons
    ##assert_equal __, ::C
    assert_equal "top level", ::C #can access C outside class using ::
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    ##assert_equal __, AboutConstants::C
    assert_equal "nested", AboutConstants::C

    ##assert_equal __, ::AboutConstants::C
    assert_equal "nested", ::AboutConstants::C
  end

  # ------------------------------------------------------------------

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    ##assert_equal __, Animal::NestedAnimal.new.legs_in_nested_animal
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    ##assert_equal __, Reptile.new.legs_in_reptile
    assert_equal 4, Reptile.new.legs_in_reptile
  end

  # ------------------------------------------------------------------

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    ##assert_equal __, MyAnimals::Bird.new.legs_in_bird
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?

  # ------------------------------------------------------------------

  # The constant in lexical scope has precedence, and overrides the constant from the inheritance hierarchy
  # Which is why the anwer is 2 and not 4


  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    ##assert_equal __, MyAnimals::Oyster.new.legs_in_oyster
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?

  # ANSWER:
  ## In Ruby, constants are retrieved first from the enclosing scope, and then from the outser scopes (up to the top
  ## level). Here, the Oyster class wasn't defined INSIDE of the MyAnimals class definition, so then the constant
  # defined in MyAnimals passed out of scope, and thus Ruby checked the parent class for the value of the constant?

end
