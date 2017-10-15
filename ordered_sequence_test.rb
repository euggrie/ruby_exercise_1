require File.join(File.dirname(__FILE__), 'sequence')
require File.join(File.dirname(__FILE__), 'job')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase

  # Case 1- if input == ""
  # It should return an empty sequence.
  def test_returns_empty_string_if_no_jobs
    sequence = Sequence.new()
    sequence.add(@no_jobs)
    assert sequence.ordered.empty?
  end

  #  Case 2- if input == "a =>"
  # It should return a single job sequence.
  # Always an ordered secuence should contain same jobs as input string.
  def test_returns_single_job_string_if_contains_one_job
    sequence = Sequence.new()
    sequence.add("a =>")
    assert_equal 1, sequence.ordered.size
    assert_equal 'a', sequence.ordered.first
  end

  # Case 3- if input == "a =>
  #                      b =>
  #                      c =>"
  # It should return a secuence that contains all jobs in no particular order.
  def test_return_multiple_idenpendent_jobs_in_any_order
    sequence = Sequence.new()
    sequence.add("a =>
               b =>
               c =>")
    sequence.ordered.each do |job|
      assert (%w[a b c].include?(job))
    end
  end

  # Case 4- if input == "a =>
  #                      b => c
  #                      c =>"
  # It should return a secuence that contains all jobs and c will be placed before b.
  def test_retuns_job_in_a_specific_order_if_only_one_has_dependency
    sequence = Sequence.new()
    sequence.add("a =>
               b => c
               c =>")
    sequence.ordered.each do |job|
      assert (%w[a b c].include?(job))
    end
    p sequence.ordered
    assert sequence.ordered.index("c") < sequence.ordered.index("b")
  end

  # Case 5- if input == "a =>
  #                      b => c
  #                      c => f
  #                      d => a
  #                      e => b
  #                      f =>"
  # It should return a secuence that contains all jobs and where b will be placed before c,
  # f before c, a before d, b before e
  def test_retuns_ordered_jobs_considering_all_dependecies
    sequence = Sequence.new()
    sequence.add("a =>
               b => c
               c => f
               d => a
               e => b
               f =>")
    sequence.ordered.each do |job|
     assert (%w[a b c d e f].include?(job))
    end
    assert sequence.ordered.index("f") < sequence.ordered.index("c")
    assert sequence.ordered.index("c") < sequence.ordered.index("b")
    assert sequence.ordered.index("b") < sequence.ordered.index("e")
    assert sequence.ordered.index("a") < sequence.ordered.index("d")
  end

  # Case 6- if input == "a =>
  #                      b =>
  #                      c => c"
  # It should raise an error stating that jobs can’t depend on themselves.
  def test_raise_error_if_contains_self_dependent_jobs
    sequence = Sequence.new()
    sequence.add("a =>
               b =>
               c => c")

    assert_raises(SelfDependencyError) do
      sequence.ordered
    end
  end

  # Case 7- if input == "a =>
  #                      b => c
  #                      c => f
  #                      d => a
  #                      e =>
  #                      f => b"
  # It should raise an error stating that jobs can’t have circular dependencies.
  def test_raise_error_if_contains_circular_dependency
    sequence = Sequence.new()
    sequence.add("a =>
               b => c
               c => f
               d => a
               e =>
               f => b")
    assert_raises(CircularDependencyError) do
      sequence.ordered
    end
  end

end
