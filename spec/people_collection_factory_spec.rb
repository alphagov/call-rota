require 'people_collection_factory'

describe PeopleCollectionFactory do
  let(:names) { ["Blue Penguin", "Red Penguin"] }
  let(:use_names) { ["B Penguin", "R Penguin"] }
  let(:blue_penguin_hash) {
    {
      :full_name        => names.first,
      :use_name         => use_names.first,
      :rota_skill_group => "developer",
      :team             => "User Formats",
    }
  }
  let(:red_penguin_hash) {
    {
      :full_name        => names[1],
      :use_name         => use_names[1],
      :rota_skill_group => "webops",
      :team             => "Product Gaps",
    }
  }

  #When this data is available, this will contain
  #information about whether person is tech lead or not
  let(:people_input_data) {
    [
      blue_penguin_hash,
      red_penguin_hash,
    ]
  }

  let(:production_access_input_data) {
    [
      red_penguin_hash,
    ]
  }

  subject(:factory) {
    described_class.new(
      people_input_data,
      production_access_input_data
    )
  }

  it "returns a collection of objects representing the input data" do
    result = factory.call
    first_result = result[0]

    expect(result).to respond_to :[]
    expect(result.size).to eq(2)
    expect(names).to include(first_result.full_name)
  end

  it "correctly determines production access" do
    result = factory.call
    with_production_access = result.select { |p| p.production_access == true }

    expect(with_production_access.size).to eq(1)
    expect(with_production_access.first.use_name).to eq("R Penguin")
  end
end
