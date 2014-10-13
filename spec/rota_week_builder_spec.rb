require "rota_week_builder"

describe RotaWeekBuilder do
  let(:red_penguin) { double(:red_penguin) }
  let(:blue_penguin) { double(:blue_penguin) }
  let(:yellow_penguin) { double(:yellow_penguin) }
  let(:penguins) { [red_penguin, blue_penguin, yellow_penguin] }

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

  context "with two people" do
    let(:penguins) { [red_penguin, yellow_penguin] }

    it "raises if not provided with enough people" do
      expect { subject.call }.to raise_error
    end
  end
end
