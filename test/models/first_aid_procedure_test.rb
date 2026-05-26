require "test_helper"

class FirstAidProcedureTest < ActiveSupport::TestCase
  def valid_procedure
    FirstAidProcedure.new(
      name: "Dog Choking",
      species: "dog",
      severity: "immediate",
      description: "A choking emergency.",
      symptom_keywords: "choking, coughing"
    )
  end

  test "valid procedure saves successfully" do
    assert valid_procedure.valid?
  end

  test "name is required" do
    p = valid_procedure
    p.name = ""
    assert_not p.valid?
    assert_includes p.errors[:name], "can't be blank"
  end

  test "description is required" do
    p = valid_procedure
    p.description = ""
    assert_not p.valid?
  end

  test "symptom_keywords is required" do
    p = valid_procedure
    p.symptom_keywords = ""
    assert_not p.valid?
  end

  test "rejects invalid species" do
    p = valid_procedure
    p.species = "goldfish"
    assert_not p.valid?
    assert_includes p.errors[:species], "must be dog, cat, rabbit, or hamster"
  end

  test "accepts all valid species" do
    %w[dog cat rabbit hamster].each do |s|
      p = valid_procedure
      p.species = s
      assert p.valid?, "Expected #{s} to be valid"
    end
  end

  test "rejects invalid severity" do
    p = valid_procedure
    p.severity = "critical"
    assert_not p.valid?
  end

  test "accepts all valid severities" do
    %w[immediate consult_vet_soon].each do |s|
      p = valid_procedure
      p.severity = s
      assert p.valid?, "Expected #{s} to be valid"
    end
  end

  test "severity_label returns correct label" do
    p = valid_procedure
    p.severity = "immediate"
    assert_equal "Immediate Action Required", p.severity_label

    p.severity = "consult_vet_soon"
    assert_equal "Consult Vet Soon", p.severity_label
  end

  test "by_species scope filters correctly" do
    FirstAidProcedure.destroy_all
    dog_p = FirstAidProcedure.create!(valid_procedure.attributes.merge("species" => "dog"))
    cat_p = FirstAidProcedure.create!(valid_procedure.attributes.merge("name" => "Cat Wound", "species" => "cat"))

    assert_includes FirstAidProcedure.by_species("dog"), dog_p
    assert_not_includes FirstAidProcedure.by_species("dog"), cat_p
  end

  test "search scope matches on name" do
    FirstAidProcedure.destroy_all
    p = FirstAidProcedure.create!(valid_procedure.attributes)
    assert_includes FirstAidProcedure.search("Choking"), p
    assert_not_includes FirstAidProcedure.search("bleeding"), p
  end
end
