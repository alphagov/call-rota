require 'people_collection_factory'

describe PeopleCollectionFactory do 
  let(:names) { ["Penguin", "Polar bear"] }

  let(:input_data) {
    [
      {
        :name                 => names.first,
        :team                 => "GOV.UK",
        :"production-access"  => "yes",
        :"tech-lead"          => "yes",
        :"role"               => "developer",
      },
      {
        :name                 => names.last,
        :team                 => "IDA",
        :"production-access"  => "no",
        :"tech-lead"          => "no",
        :"role"               => "webops",
      },
    ]
  }

  subject(:factory) { described_class.new(input_data) }

  it "returns a collection of objects representing the input data" do
    result = factory.call
    first_result = result[0]

    expect(result).to respond_to :[]
    expect(result.size).to eq(2)
    expect(names).to include(first_result.name)
  end
end
