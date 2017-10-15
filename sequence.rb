class Sequence

  def initialize
  end

  def ordered
  end

end


class SelfDependencyError < StandardError; end
class CircularDependencyError < StandardError; end
