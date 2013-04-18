module SimpleSerializer
  module Associations
  end
end

%w(association has_many has_one).each do |filename|
  require File.join('simple_serializer', 'associations', filename)
end
