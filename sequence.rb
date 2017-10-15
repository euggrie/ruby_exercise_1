class Sequence

  def initialize
    @jobs = []
  end

  def add(input)
    input.split("\n").each do |line| # return each line as a string "b => c"
      job = Job.new(line) # takes a line and convert it to an array and then assign it to @job and @dependecy as strings
      @jobs.push(job) unless @jobs.include?(job) # push job instances to an array @jobs
    end
  end

  # Will take array containing all job bjects and return array with new order.
  def ordered
    # to do
  end

end


class SelfDependencyError < StandardError; end
class CircularDependencyError < StandardError; end
