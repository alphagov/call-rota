require 'people_collection_factory'

describe PeopleCollectionFactory do 
  let(:input_data) {
    [
      {
        :name                 => "Penguin", 
        :team                 => "GOV.UK",
        :"production-access"  => "yes",
        :"tech-lead"          => "yes",
        :"role"               => "developer",
      },
      {
        :name                 => "Polar bear", 
        :team                 => "IDA",
        :"production-access"  => "no",
        :"tech-lead"          => "no",
        :"role"               => "webops",
      },
    ]
  }

  subject(:factory) { described_class.new(input_data) }

  it "returns a collection" do
    expect(factory.call).to respond_to :[]
  end
end