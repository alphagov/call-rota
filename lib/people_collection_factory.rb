require "ostruct"

class PeopleCollectionFactory
  def initialize(input_data)
    @input_data = input_data
  end

  def call
    input_data.map do |person_hash|
      build_person(person_hash)
    end
  end

private
  attr_reader :input_data

  def build_person(person_hash)
    OpenStruct.new(person_hash)
  end
end
