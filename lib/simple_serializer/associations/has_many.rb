module SimpleSerializer
  module Associations

    class HasMany < Association
      def self.has_many?
        true
      end
    end

  end
end
