class RotaWeekBuilder
  def initialize(people)
    @people = people
  end

  def call
    RotaWeek.new(
      :web_ops => pick_person("webops"),
      :dev => pick_person("developer"),
      :supplemental_dev => pick_person("developer"),
    )
  end

private

  def pick_person(role)
    people_with_role = available_people(role)
    raise "No more people to pick for role #{role}!" if people_with_role.empty?

    people_with_role.sample.tap do |chosen_person|
      chosen_people.push chosen_person
    end
  end

  def available_people(role)
    people_with_role(role) - chosen_people
  end

  def chosen_people
    @chosen_people ||= []
  end

  def people_with_role(role)
    @people.select { |p| p.rota_skill_group == role }
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
