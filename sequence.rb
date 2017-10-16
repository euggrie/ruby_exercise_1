class Sequence

  def initialize
    @jobs = []
  end

  def add(input)
    input.split("\n").each do |line| # returns each line as a string "b => c"
      job = Job.new(line) # takes a line and convert it to an array and then assign it to @job and @dependecy as strings
      @jobs.push(job) unless @jobs.include?(job) # pushes job instances to an array @jobs
    end
  end

  # takes array containing all job objects and return array with new order.
  def ordered
    @jobs.reduce([]) do |order, job| # creates a new array and add jobs' names and dependencies, unless the job's name already exists in the array.
      order.push(job.name) unless order.include?(job.name)

      # if a job has a dependency
      if job.has_dependency?
        raise SelfDependencyError if job.dependency == job.name #raises error if it's itself

        order.delete(job.dependency) # or deletes it from array

        dependent_position = order.index(job.name)
        order.insert(dependent_position, job.dependency) # and inserts job dependency before the job index
      end
      order # returns array
    end
  end

end


class SelfDependencyError < StandardError; end
class CircularDependencyError < StandardError; end
