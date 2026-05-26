require "test_helper"

class AdminStepsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @procedure = FirstAidProcedure.create!(
      name: "Dog Choking",
      species: "dog",
      severity: "immediate",
      description: "A choking emergency.",
      symptom_keywords: "choking"
    )
  end

  def step_params(overrides = {})
    {
      position: 1,
      instruction: "Open the mouth and check for a visible object.",
      checklist: "Dog is breathing\nContact an emergency vet clinic immediately"
    }.merge(overrides)
  end

  test "admin can create step" do
    assert_difference("@procedure.steps.count", 1) do
      post admin_first_aid_procedure_steps_url(@procedure), params: { step: step_params }
    end

    assert_redirected_to admin_first_aid_procedure_steps_url(@procedure)
  end

  test "admin can update step" do
    step = @procedure.steps.create!(step_params)

    patch admin_first_aid_procedure_step_url(@procedure, step), params: {
      step: step_params(instruction: "Apply controlled abdominal thrusts.")
    }

    assert_redirected_to admin_first_aid_procedure_steps_url(@procedure)
    assert_equal "Apply controlled abdominal thrusts.", step.reload.instruction
  end

  test "admin can delete step" do
    step = @procedure.steps.create!(step_params)

    assert_difference("@procedure.steps.count", -1) do
      delete admin_first_aid_procedure_step_url(@procedure, step)
    end

    assert_redirected_to admin_first_aid_procedure_steps_url(@procedure)
  end
end
