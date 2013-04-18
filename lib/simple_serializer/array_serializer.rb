module SimpleSerializer

  class ArraySerializer

    def initialize(array, klass)
      @array = array
      @klass = klass
    end

    def as_json
      @array.map do |model|
        @klass.new(model).as_json
      end
    end

  end

end

