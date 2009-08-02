module Matchers
  class SameTimeAs
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      @target.hour == @expected.hour && @target.min == @expected.min
    end

    def failure_message
      "expected #{to_string(@target)} to " +
      "the same as #{to_string(@expected)}"
    end

    def negative_failure_message
      "expected #{to_string(@target)} not to " +
      "be the same as #{to_string(@expected)}"
    end

    # Returns string representation of an object.
    def to_string(value)
      # indicate a nil
      if value.nil?
        'nil'
      end

      # otherwise return to_s() instead of inspect()
      return value.strftime("%H:%M")
    end
  end

  # Actual matcher that is exposed.
  def be_same_time_as(expected)
    SameTimeAs.new(expected)
  end
end

