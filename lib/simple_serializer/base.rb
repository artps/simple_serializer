module SimpleSerializer

  class Base

    class << self

      def attribute(*attrs)
        options = attrs.extract_options!

        if attrs.size == 0 && options.present?
          attr = attrs.shift
          attributes << attr
          synonyms[attr] = options[:as]
        else
          attrs.map do |attr|
            attributes << attr
          end
        end
      end

      def attributes
        @attributes ||= []
      end

      def synonyms
        @synonyms ||= {}
      end

      def serialize(array)
        ArraySerializer.new(array, self)
      end

    end

    def initialize(model)
      @model = model
    end

    attr_reader :model

    def to_json
      serialize_model(model)
    end

    private

    def serialize_model(model)
      Hash[self.class.attributes.map do |attr|
        json_attr_name = self.class.synonyms.fetch(attr, attr)

        value = if respond_to?(attr)
          send(attr)
        else
          model.send(attr)
        end

        [json_attr_name, value]
      end]
    end

  end

end
