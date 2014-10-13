class PeopleCollectionFactory
  def initialize(input_data)
    @input_data = input_data
  end

  def call
    []
  end

private
  attr_reader :input_data
end