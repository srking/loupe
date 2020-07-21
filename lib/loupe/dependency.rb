module Loupe
  Dependency = Struct.new(:type, :name, :from_version, :to_version, keyword_init: true) do
    def level
      from = Gem::Version.new(from_version)
      to = Gem::Version.new(to_version)
      if from.segments[0] != to.segments[0]
        :major
      elsif from.segments[1] != to.segments[1]
        :minor
      elsif from.segments[2] != to.segments[2]
        :patch
      end
    end
  end
end
