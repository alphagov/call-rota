require "rota_week_builder"
require "helpers/test_penguin_factories"

describe RotaWeekBuilder do
  let(:penguins) {
    test_penguin_team_factory = TestPenguinFactories::TeamFactory.new(
      method(:double),
      webops: 2,
      developers_with_prod: 2,
      developers_without_prod: 10,
    )
    TestPenguinFactories::ColonyFactory.new(method(:double)).call(
      teams: 3,
      test_penguin_team_factory: test_penguin_team_factory,
    )
  }

  subject(:builder) { RotaWeekBuilder.new(penguins) }

  let(:result) { subject.call }

  it "returns a collection for the next week" do
    expect(result.web_ops).not_to be(nil)
    expect(result.dev).not_to be(nil)
    expect(result.supplemental_dev).not_to be(nil)
    expect(result.count).to eq(3)
  end

  it "returns three different people" do
    people = result.map.to_a
    expect(people.uniq.size).to eq(3)
  end

  it "returns people of the right role for their allocated job" do
    expect(result.web_ops.rota_skill_group).to eq("webops")
    expect(result.dev.rota_skill_group).to eq("developer")
    expect(result.supplemental_dev.rota_skill_group).to eq("developer")
  end

  it "returns a primary dev with production access" do
    expect(result.dev.production_access).to be true
  end

  it "returns people from different teams" do
    people = [result.dev, result.supplemental_dev, result.web_ops]

    expect(people.map(&:team).uniq.size).to eq 3
  end

  context "with two people" do
    let(:penguins) {
      TestPenguinFactories::TeamFactory.new(
        method(:double),
        webops: 1,
        developers_with_prod: 0,
        developers_without_prod: 1,
      ).call
    }

    it "raises if not provided with enough people" do
      expect { subject.call }.to raise_error
    end
  end
end
