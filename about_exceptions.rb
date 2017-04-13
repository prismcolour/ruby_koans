require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutExceptions < Neo::Koan

  class MySpecialError < RuntimeError
  end

  def test_exceptions_inherit_from_Exception
    assert_equal RuntimeError, MySpecialError.ancestors[1]
    assert_equal StandardError, MySpecialError.ancestors[2]
    assert_equal Exception, MySpecialError.ancestors[3]
    assert_equal Object, MySpecialError.ancestors[4]
  end

  # Stuck the rest of this section
  # Researching more on exceptions
  # http://stackoverflow.com/questions/3563111/
  # is-there-a-supplementary-guide-answer-key-for-ruby-koans
  
  # Guide: http://rubylearning.com/satishtalim/ruby_exceptions.html
  
  def test_rescue_clause
    result = nil
    begin
      # raise and fail are synonyms hence the ex.message is "Oops"
      fail "Oops"
    rescue StandardError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result

    assert_equal true, ex.is_a?(StandardError), "Should be a Standard Error"
    assert_equal true, ex.is_a?(RuntimeError),  "Should be a Runtime Error"

    assert RuntimeError.ancestors.include?(StandardError),
      "RuntimeError is a subclass of StandardError"

    assert_equal "Oops", ex.message
  end

  # Syntax comment: 
  # => is a special case, reserved for rescue clauses
  # It assigns the exception raised to the `ex` variable.
  # rescue MySpecialError => ex
  # ex can be used as an object and can apply Exception methods like
  # backtrace and message
  # https://www.ruby-forum.com/topic/3440938
  
  def test_raising_a_particular_error
    result = nil
    begin
      # 'raise' and 'fail' are synonyms
      # Feeding in exception subclass MySpecialError with "My Message"
      raise MySpecialError, "My Message"
    rescue MySpecialError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result
    assert_equal "My Message", ex.message
  end

  # Ensure code block to make sure the last block always runs
  # even if no exceptions caught 
  # Ensure used within the begin/end rescue block
  
  def test_ensure_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError
      # no code here
    ensure
      result = :always_run
    end

    assert_equal :always_run, result
  end

  # Sometimes, we must know about the unknown
  # Still not sure how to use an assert_raise
  def test_asserting_an_error_is_raised
    # A do-end is a block, a topic to explore more later
    assert_raise(MySpecialError) do
      raise MySpecialError.new("New instances can be raised directly.")
    end
  end

end
