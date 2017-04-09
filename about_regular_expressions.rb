# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/]
    assert_equal "a", "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    # If the beginning of the pattern isn't found.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  # They will try to match as much of the pattern as possible.

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    assert_equal "42", "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # A word character is a character from a-z, A-Z, 0-9, 
    # including the _ (underscore) character.
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    # Metacharacters ., \w, \W, \d, \D, \s, \S
    # https://www3.ntu.edu.sg/home/ehchua/programming/howto/Regexe.html
    # D character not a digit 
    # d all digits
    assert_equal "the number is ", "the number is 42"[/\D+/]
    assert_equal "space:", "space: \t\n"[/\S+/]
    # ... a programmer would most likely do
    # Common regex pattern [^a-zA-Z0-9_]
    # Match the underscore character in addition to lowercase letters, 
    # uppercase letters, and numbers.
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    assert_equal " = ", "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------

  def test_slash_a_anchors_to_the_start_of_the_string
    # https://www3.ntu.edu.sg/home/ehchua/programming/howto/Regexe.html
    #  Positional Metacharacters (aka Position Anchors) 
    # ^, $, \b, \B, \<, \>, \A, \Z
    # Matches the beginning of the line
    
    assert_equal "start", "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/]
  end

  def test_slash_b_anchors_to_a_word_boundary
    # https://www3.ntu.edu.sg/home/ehchua/programming/howto/Regexe.html
    #  \b matches the the edge of a word 
    # (i.e., word boundary after a whitespace); 
    # and \B matches a string provided it's not at the edge of a word
    # Matches the boundary between /w and /W 
    # . matches all characters that is not going to be new line /n
    # http://stackoverflow.com/questions/1324676/
    # what-is-a-word-boundary-in-regexes
    
    assert_equal "vines", "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  def test_parentheses_group_contents
    
    # [] denotes a character class. () denotes a capturing group.
    # [a-z0-9] -- One character that is in the range of a-z OR 0-9
    # (a-z0-9) -- Explicit capture of a-z0-9. No ranges.
    # http://stackoverflow.com/questions/3789417/
    # whats-the-difference-between-and-in-regular-expression-patterns
    
    assert_equal "hahaha", "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  def test_parentheses_also_capture_matched_content_by_number
    # Bring back words via what order they are in
    # ie. first word, second word 
    
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2]
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1
    assert_equal "James", $2
  end

  # ------------------------------------------------------------------

  def test_a_vertical_pipe_means_or
    # Alternation to match a single regular expression out of 
    # several possible regular expressions
    # http://www.regular-expressions.info/alternation.html
    
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    assert_equal "Summer", "Summer Gray"[grays, 1]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).

  # ------------------------------------------------------------------

  def test_scan_is_like_find_all
    # - is not a word
    # _ is a word 
    # A word character is a character from a-z, A-Z, 0-9, 
    # including the _ (underscore) character.
    
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
  end

  def test_sub_is_like_find_and_replace
    # Similar to sed in unix
    # http://stackoverflow.com/questions/4626425/
    # ruby-regex-question-wrt-the-sub-method-on-string
    # { $1[0,1] } $1 string 1 is accessing index 0 and return 1 character
    # capture group is t and words, only returns the first find which is two
    # Two gets put into $1 and returns t
    # (/(t\w*)/) search portion
    # { $1[0, 1] } replace portion
  
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    # Similar to global sed
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end
