module SimpleSerializer

  class ArraySerializer

    def initialize(array, klass)
      @array = array
      @klass = klass
    end

    def to_json
      @array.map do |model|
        @klass.new(model).to_json
      end
    end

  end

end

