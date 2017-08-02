module Searchbot::Generic::Concerns
  module Html

    private

    def html
      @html ||= fetch(url)
    end

    def doc
      @doc ||= begin
        raw = html.respond_to?(:to_html) ? html : Nokogiri::HTML(html)

        unless raw.encoding # https://github.com/sparklemotion/nokogiri/issues/215 (sparked by iaquisitions)
          raw = Nokogiri::HTML( raw.to_html(encoding: 'UTF-8') )
        end

        prepare_doc(raw)
      end
    end

    # Hook for subclasses to narrow down scope
    def prepare_doc(raw)
      raw
    end

  end
end
