class RotaWeekBuilder
  def initialize(people)
    @people = people
  end

  def call
    RotaWeek.new(
      :web_ops => pick_person("webops"),
      :dev => pick_person("developer", true),
      :supplemental_dev => pick_person("developer"),
    )
  end

private

  def pick_person(role, production_access=false)
    eligible_people = available_people(role, production_access)
    if eligible_people.empty?
      raise "No more people to pick for role #{role}
            #{production_access ? "with production access" : ""}!"
    end
    eligible_people.sample.tap do |chosen_person|
      chosen_people.push chosen_person
    end
  end

  def available_people(role, production_access)
    people_with_role_and_access(role, production_access) - chosen_people
  end

  def chosen_people
    @chosen_people ||= []
  end

  def people_with_role_and_access(role, production_access)
    result = @people.dup
    if production_access
      result = result.select { |p| p.production_access == true }
    end
    result.select { |p| p.rota_skill_group == role }
  end

end

class RotaWeek
  include Enumerable

  attr_reader :web_ops, :dev, :supplemental_dev

  def initialize(web_ops:, dev:, supplemental_dev:)
    @web_ops = web_ops
    @dev = dev
    @supplemental_dev = supplemental_dev
  end

  def each
    yield web_ops
    yield dev
    yield supplemental_dev
  end
end
