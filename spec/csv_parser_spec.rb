require "csv_parser"

describe CSVParser do
  let(:people_input_csv) {
<<-EOF
Full Name,Use Name,Rota Skill Group,Team
"Doe, Jane",Jane D,Dev,PDU
"Smith, John",John S,Dev (Supp),Product Gaps
"Bloggs, Joe",Joe B,Dev,Infrastructure
"Fenton, Peter",Peter F,Web Ops,Product Gaps
EOF
  }
  let(:production_access_input_csv) {
<<-EOF
Full Name,Use Name,Rota Skill Group,Team
"Doe, Jane",Jane D,Dev,PDU
EOF
  }

  let(:desired_people_data) {
    [
      {
        full_name: "Doe, Jane",
        use_name: "Jane D",
        rota_skill_group: "developer",
        team: "PDU",
      },
      {
        full_name: "Smith, John",
        use_name: "John S",
        rota_skill_group: "developer",
        team: "Product Gaps",
      },
      {
        full_name: "Bloggs, Joe",
        use_name: "Joe B",
        rota_skill_group: "developer",
        team: "Infrastructure",
      },
      {
        full_name: "Fenton, Peter",
        use_name: "Peter F",
        rota_skill_group: "webops",
        team: "Product Gaps",
      },
    ]
  }

  let(:desired_production_access_data) {
    [
      {
        use_name: "Jane D",
      },
    ]
  }

  subject(:parser) { described_class.new(people_input_csv, production_access_input_csv) }

  it "correctly normalizes the rota_skill_group" do
    people = parser.people_data

    uniq_skill_groups = people.map { |p| p[:rota_skill_group] }.uniq

    jane_d = people.find { |p| p[:use_name] == "Jane D" }
    john_s = people.find { |p| p[:use_name] == "John S" }
    peter_f = people.find { |p| p[:use_name] == "Peter F" }

    expect(uniq_skill_groups).to eq(["developer", "webops"])

    expect(jane_d[:rota_skill_group]).to eq("developer")
    expect(john_s[:rota_skill_group]).to eq("developer")
    expect(peter_f[:rota_skill_group]).to eq("webops")
  end

  it "returns correct people data" do
    expect(parser.people_data).to eq(desired_people_data)
  end

  it "returns correct production access data" do
    expect(parser.production_access_data).to eq(desired_production_access_data)
  end
end
