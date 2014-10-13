require "rota_week_builder"

class TestPenguinFactory
  include RSpec::Mocks

  def initialize(generator)
    @generator = generator
  end

  def call(webops:, developers_with_prod:, developers_without_prod:)
    result = []

    webops.times do
      result << webops_penguin_factory.call
    end

    developers_with_prod.times do
      result << developers_penguin_factory.call(true)
    end

    developers_without_prod.times do
      result << developers_penguin_factory.call(false)
    end

    result
  end

private
  def webops_penguin_factory
    ->() {
      double(:webops_penguin,
        rota_skill_group: "webops",
        production_access: true,
      )
    }
  end

  def developers_penguin_factory
    ->(production_access) {
      double(:developer_penguin,
        rota_skill_group: "developer",
        production_access: production_access,
      )
    }
  end

  def double(symbol, *args)
    @generator.call(symbol, *args)
  end
end

describe RotaWeekBuilder do
  let(:penguins) {
    TestPenguinFactory.new(method(:double)).call(
      webops: 2,
      developers_with_prod: 2,
      developers_without_prod: 10,
    )
  }

  subject(:builder) { RotaWeekBuilder.new(penguins) }

  it "returns a collection for the next week" do
    result = subject.call
    expect(result.web_ops).not_to be(nil)
    expect(result.dev).not_to be(nil)
    expect(result.supplemental_dev).not_to be(nil)
    expect(result.count).to eq(3)
  end

  it "returns three different people" do
    result = subject.call
    people = result.map.to_a
    expect(people.uniq.size).to eq(3)
  end

  it "returns people of the right role for their allocated job" do
    result = subject.call

    expect(result.web_ops.rota_skill_group).to eq("webops")
    expect(result.dev.rota_skill_group).to eq("developer")
    expect(result.supplemental_dev.rota_skill_group).to eq("developer")
  end

  it "returns a primary dev with production access" do
    result = subject.call

    expect(result.dev.production_access).to be true
  end

  context "with two people" do
    let(:penguins) {
      TestPenguinFactory.new(method(:double)).call(
        webops: 1,
        developers_with_prod: 0,
        developers_without_prod: 1,
      )
    }

    it "raises if not provided with enough people" do
      expect { subject.call }.to raise_error
    end
  end
end
