module Searchbot::Utils::Parsing

  def str2i(str)
    str.to_s.gsub(/[^\d.]/, '').to_i
  end

end