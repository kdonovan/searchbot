class Searchbot::Sources::IAcquisitions::DetailParser < Searchbot::Generic::DetailParser

  parses :description

  def description
    node = doc.at('.info')
    node = node.next until node.name == 'p'
    sane node.text
  end

  private

end
