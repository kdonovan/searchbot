class Sources::Base

  attr_reader :filters

  def initialize(filters, opts = {})
    @filters = filters
    @results = nil
  end

  def results
    retrieve_results if @results.nil?
    @results
  end

  private

  def url_for_page
    raise "Must be implemented in child class"
  end

  def parse_results_page(doc)
    raise "Must be implemented in child class"
  end

  def parse_single_result(raw)
    raise "Must be implemented in child class"
  end

  def retrieve_results
    @results = []
    more_pages = true
    curr_page = 1

    while more_pages do
      url = url_for_page(curr_page)
      doc = Nokogiri::HTML( open(url).read )

      begin
        more_pages = parse_results_page(doc)
      rescue PreviouslySeen
        break
      end

      curr_page += 1
    end
  end

  def mark_all_seen
    to_write = seen + unseen.map(&:id)

    File.open(seen_file, "w") do |file|
      file.puts to_write.uniq.join(',')
    end
  end

  def seen
    []  # NOT currently implemented
  end

  def unseen
    @unseen ||= results.reject {|result| seen.include?(result.id) }
  end

end
