module SimpleSerializer
end

%w(base array_serializer).each do |filename|
  require File.join('simple_serializer', filename)
end
