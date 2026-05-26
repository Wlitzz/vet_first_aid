require "test_helper"

class AdminFirstAidProceduresControllerTest < ActionDispatch::IntegrationTest
  def procedure_params(overrides = {})
    {
      name: "Dog Choking",
      species: "dog",
      severity: "immediate",
      description: "A choking emergency.",
      symptom_keywords: "choking, coughing"
    }.merge(overrides)
  end

  test "admin can create procedure" do
    assert_difference("FirstAidProcedure.count", 1) do
      post admin_first_aid_procedures_url, params: { first_aid_procedure: procedure_params }
    end

    assert_redirected_to admin_first_aid_procedure_url(FirstAidProcedure.last)
    follow_redirect!
    assert_match "Procedure created successfully", response.body
  end

  test "admin can update procedure" do
    procedure = FirstAidProcedure.create!(procedure_params)

    patch admin_first_aid_procedure_url(procedure), params: {
      first_aid_procedure: procedure_params(name: "Dog Choking Updated")
    }

    assert_redirected_to admin_first_aid_procedure_url(procedure)
    assert_equal "Dog Choking Updated", procedure.reload.name
  end

  test "admin can delete procedure" do
    procedure = FirstAidProcedure.create!(procedure_params)

    assert_difference("FirstAidProcedure.count", -1) do
      delete admin_first_aid_procedure_url(procedure)
    end

    assert_redirected_to admin_first_aid_procedures_url
  end
end
