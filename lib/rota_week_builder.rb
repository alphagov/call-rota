class RotaWeekBuilder
  def initialize(people)
    @people = people
  end

  def call
    RotaWeek.new(
      :web_ops => pick_person,
      :dev => pick_person,
      :supplemental_dev => pick_person,
    )
  end

private

  def pick_person
    raise "No more people to pick!" if available_people.empty?

    available_people.sample.tap do |chosen_person|
      chosen_people.push chosen_person
    end
  end

  def available_people
    @people - chosen_people
  end

  def chosen_people
    @chosen_people ||= []
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
