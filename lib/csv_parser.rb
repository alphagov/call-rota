require 'csv'

class CSVParser
  def initialize(people_string, production_access_string)
    @people_string = people_string
    @production_access_string = production_access_string
  end

  def people_data
    parsed_csv_data(@people_string).map do |parsed_person|
      parsed_person[:rota_skill_group] = normalize_skill_group(parsed_person)
      parsed_person
    end

  end

  def production_access_data
    parsed_csv_data(@production_access_string).map do |parsed_person|
      {:use_name => parsed_person.fetch(:use_name)}
    end
  end

private

  def normalize_skill_group(parsed_person)
    SKILL_GROUPS.fetch(parsed_person[:rota_skill_group])
  end

  def parsed_csv_data(string)
    csv = CSV.new(
      string,
      :headers           => true,
      :header_converters => :symbol,
    )
    csv.to_a.map {|row| row.to_hash }
  end

  SKILL_GROUPS = {
    "Dev"        => "developer",
    "Dev (Supp)" => "developer",
    "Web Ops"    => "webops",
  }
end
