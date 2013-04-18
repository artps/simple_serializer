module SimpleSerializer
  module Associations

    class Association
      def self.has_many?
        false
      end

      def self.has_one?
        false
      end
    end

  end
end
