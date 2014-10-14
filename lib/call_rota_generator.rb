require "csv_parser"
require "people_collection_factory"
require "rota_week_builder"

class CallRotaGenerator
  def initialize(options)
    @options = options
  end

  def call
    RotaWeekBuilder.new(people_collection).call
  end

private
  def options
    @options
  end

  def people_string
    File.read(options[:people])
  end

  def production_access_string
    File.read(options[:production])
  end

  def csv_parser
    @parser ||= CSVParser.new(people_string, production_access_string)
  end

  def people_collection
    PeopleCollectionFactory.new(
      csv_parser.people_data,
      csv_parser.production_access_data,
    ).call
  end
end
