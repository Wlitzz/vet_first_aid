require "test_helper"

class StepsControllerTest < ActionDispatch::IntegrationTest
  def setup
    FirstAidProcedure.destroy_all
    @procedure = FirstAidProcedure.create!(
      name: "Dog Choking", species: "dog", severity: "immediate",
      description: "A choking emergency.", symptom_keywords: "choking"
    )
    @step1 = Step.create!(first_aid_procedure: @procedure, position: 1, instruction: "Open the mouth.")
    @step2 = Step.create!(first_aid_procedure: @procedure, position: 2, instruction: "Apply thrusts.")
    @step3 = Step.create!(first_aid_procedure: @procedure, position: 3, instruction: "Transport to vet.")
  end

  test "GET step show returns success" do
    get first_aid_procedure_step_url(@procedure, @step1)
    assert_response :success
    assert_match "Open the mouth", response.body
  end

  test "step show displays step number and total" do
    get first_aid_procedure_step_url(@procedure, @step2)
    assert_match "Step 2", response.body
    assert_match "of 3", response.body
  end

  test "first step has no Back to previous step link" do
    get first_aid_procedure_step_url(@procedure, @step1)
    assert_no_match "first_aid_procedure_step", response.body.gsub(first_aid_procedure_step_url(@procedure, @step1), "")
  end

  test "last step shows Finish button" do
    get first_aid_procedure_step_url(@procedure, @step3)
    assert_match "Finish", response.body
  end

  test "middle step shows Next link" do
    get first_aid_procedure_step_url(@procedure, @step2)
    assert_match "Next", response.body
  end
end
