module Searchbot::Generic::Concerns
  module Html

    def html
      @html ||= fetch(url)
    end

    def doc
      @doc ||= html.respond_to?(:to_html) ? html : Nokogiri::HTML(html)
    end

  end
end
