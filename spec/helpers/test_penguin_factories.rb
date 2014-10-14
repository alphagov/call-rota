module TestPenguinFactories
  class ColonyFactory
    include RSpec::Mocks

    def initialize(generator)
      @generator = generator
    end

    def call(teams:, test_penguin_team_factory:)
      result = []

      teams.times do |i|
        result += test_penguin_team_factory.call("team_#{i}")
      end

      result
    end
  end

  class TeamFactory
    include RSpec::Mocks

    def initialize(generator, webops:, developers_with_prod:, developers_without_prod:)
      @generator = generator
      @webops = webops
      @developers_with_prod = developers_with_prod
      @developers_without_prod = developers_without_prod
    end

    def call(team_name = "team_name")
      result = []

      @webops.times do
        result << webops_penguin_factory.call(team_name)
      end

      @developers_with_prod.times do
        result << developers_penguin_factory.call(team_name, true)
      end

      @developers_without_prod.times do
        result << developers_penguin_factory.call(team_name, false)
      end

      result
    end

  private
    def webops_penguin_factory
      ->(team_name) {
        double(:webops_penguin,
          team: team_name,
          rota_skill_group: "webops",
          production_access: true,
        )
      }
    end

    def developers_penguin_factory
      ->(team_name, production_access) {
        double(:developer_penguin,
          team: team_name,
          rota_skill_group: "developer",
          production_access: production_access,
        )
      }
    end

    def double(symbol, *args)
      @generator.call(symbol, *args)
    end
  end
end
