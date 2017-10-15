class Job

  attr_accessor :name, :dependency

  # Takes a line like "a => b" and returns @job = "a" and @dependency = "b"
  # converting it first to and array and then removing white spaces.
  def initialize(input)
    @name, @dependency = input.split(/ => ?/).map { |line| line.strip }
  end

  # If the is no dependency in the input string, the previous method will assign
  # the value nil to @dependency so we need to check if before using it.
  def has_dependency?
    return true unless @dependency.nil?
  end

end
