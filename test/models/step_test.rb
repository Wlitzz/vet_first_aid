require "test_helper"

class StepTest < ActiveSupport::TestCase
  def setup
    @procedure = FirstAidProcedure.create!(
      name: "Dog Choking", species: "dog", severity: "immediate",
      description: "A choking emergency.", symptom_keywords: "choking"
    )
  end

  def valid_step
    Step.new(first_aid_procedure: @procedure, position: 1, instruction: "Open the mouth and look inside.")
  end

  test "valid step saves successfully" do
    assert valid_step.valid?
  end

  test "instruction is required" do
    s = valid_step
    s.instruction = ""
    assert_not s.valid?
    assert_includes s.errors[:instruction], "can't be blank"
  end

  test "position must be a positive integer" do
    s = valid_step
    s.position = 0
    assert_not s.valid?

    s.position = -1
    assert_not s.valid?
  end

  test "position must be unique within a procedure" do
    valid_step.save!
    duplicate = Step.new(first_aid_procedure: @procedure, position: 1, instruction: "Another step.")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:position], "already taken for this procedure"
  end

  test "same position in different procedures is allowed" do
    other = FirstAidProcedure.create!(
      name: "Cat Wound", species: "cat", severity: "immediate",
      description: "Wound care.", symptom_keywords: "bleeding"
    )
    valid_step.save!
    step2 = Step.new(first_aid_procedure: other, position: 1, instruction: "Wrap the cat.")
    assert step2.valid?
  end

  test "checklist_items splits by newline" do
    s = valid_step
    s.checklist = "Check breathing\nCheck gums\nContact vet"
    assert_equal ["Check breathing", "Check gums", "Contact vet"], s.checklist_items
  end

  test "checklist_items returns empty array when checklist is blank" do
    s = valid_step
    s.checklist = nil
    assert_equal [], s.checklist_items
  end
end
