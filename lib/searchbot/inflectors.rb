module Searchbot
  module Inflectors

    def self.camelize(str)
      str.to_s.split('_').map(&:capitalize).join
    end

  end
end