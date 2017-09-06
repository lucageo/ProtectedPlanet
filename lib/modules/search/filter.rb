class Search::Filter
  def initialize term, options
    Rails.logger.info("---------LOGGER----------")
    Rails.logger.info("Search::Filter initialize")
    Rails.logger.info(options)
    @options = options
    @term = standardise(term)
  end

  def to_h
    filter.to_h
  end

  def self.from_params params
    Rails.logger.info("---------LOGGER----------")
    Rails.logger.info("Search::Filter from_params")
    Rails.logger.info(params)
    constructed_filters = []

    params.each do |name, value|
      filter = self.new(value, configuration[name.to_s]).to_h
      constructed_filters << {
        "bool" => {
          "should" => Array.wrap(filter)
        }
      }
    end

    constructed_filters
  end

  private

  CONVERSIONS = {
    "iucn_category" => -> (value) { Array.wrap(value) },
    "location" => -> (value) {
      value.tap { |v|
        v[:coords] = v[:coords].map(&:to_f)
        v[:distance] = v[:distance].to_f
      }
    }
  }

  def self.configuration
    Search.configuration['filters']
  end

  def standardise value
    CONVERSIONS[@options['path'].to_s].call(value) rescue value
  end

  def filter
    Rails.logger.info("----------LOGGER-----------")
    Rails.logger.info("Search::Filter filter")
    Rails.logger.info(@options)
    filter_type  = @options['type'].classify
    filter_class = "Search::Filter::#{filter_type}".constantize

    filter_class.new @term, @options
  end
end
