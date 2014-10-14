require "ostruct"

class PeopleCollectionFactory
  def initialize(people_inputs, deploy_access_inputs)
    @people_inputs = people_inputs
    @people_with_deploy_access = production_access_use_names(deploy_access_inputs)
  end

  def call
    @people_inputs.map do |person_hash|
      build_person(
        person_hash,
        deploy_access?(person_hash[:use_name]),
      )
    end
  end

private
  def build_person(person_hash, has_production_access)
    OpenStruct.new(
      person_hash.merge(production_access: has_production_access)
    )
  end

  def production_access_use_names(raw_deploy_access_inputs)
    raw_deploy_access_inputs.map { |p| p[:use_name] }
  end

  def deploy_access?(person_use_name)
    @people_with_deploy_access.include? person_use_name
  end
end
