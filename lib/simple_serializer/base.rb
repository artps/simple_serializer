module SimpleSerializer

  class Base

    class_attribute :_attributes
    self._attributes = {}

    class_attribute :_associations
    self._associations = {}

    class << self

      def attribute(name, options = {})
        self._attributes = _attributes.merge(name => options)
      end

      def attributes(*attrs)
        self._attributes = _attributes.dup

        attrs.each do |attr|
          attribute(attr)
        end
      end

      def serialize(array)
        if array.respond_to?(:to_ary)
          ArraySerializer.new(array, self)
        else
          new(array).as_json
        end
      end

      def associate(klass, name, *args)
        serializer, options = process_args(*args)
        self._associations = _associations.dup
        self._associations[name] = klass
        attribute(name, options.merge(serializer: serializer))
      end

      def has_many(name, *args)
        associate(Associations::HasMany, name, *args)
      end

      def has_one(name, *args)
        associate(Associations::HasOne, name, *args)
      end

      def process_args(*args)
        options = args.extract_options!
        serializer = args.shift # TODO: try to get default serializer. For example, has_many :educations → EducationSerializer

        [serializer, options]
      end

    end

    def initialize(model)
      @model = model
    end

    attr_reader :model

    def as_json
      serialize_model(model)
    end

    private

    def serialize_model(model)
      Hash[_attributes.map do |(attr, options)|
        [(options[:as] || attr), calculate_attribute_value(attr, options[:serializer])]
      end]
    end

    def calculate_attribute_value(name, serializer)
      if _associations.has_key?(name)
        klass = _associations[name]
        relation = model.try(name)

        method = if klass.has_many?
          :serialize
        else
          :new
        end

        serializer.send(method, relation).as_json
      elsif respond_to?(name)
        send(name)
      else
        model.send(name)
      end
    end

  end

end
