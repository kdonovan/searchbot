module Searchbot::Generic::Concerns
  module Html

    private

    def html
      @html ||= fetch(url)
    end

    def doc
      @doc ||= begin
        raw = html.respond_to?(:to_html) ? html : Nokogiri::HTML(html)
        prepare_doc(raw)
      end
    end

    # Hook for subclasses to narrow down scope
    def prepare_doc(raw)
      raw
    end

  end
end
