module SimpleSerializer
  module Associations

    class HasOne < Association
      def self.has_one?
        true
      end
    end

  end
end
