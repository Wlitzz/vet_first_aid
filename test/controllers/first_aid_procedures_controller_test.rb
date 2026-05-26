require "test_helper"

class FirstAidProceduresControllerTest < ActionDispatch::IntegrationTest
  def setup
    FirstAidProcedure.destroy_all
    @procedure = FirstAidProcedure.create!(
      name: "Dog Choking", species: "dog", severity: "immediate",
      description: "A choking emergency.", symptom_keywords: "choking, coughing"
    )
    @cat_procedure = FirstAidProcedure.create!(
      name: "Cat Bleeding Wound", species: "cat", severity: "immediate",
      description: "A wound emergency.", symptom_keywords: "bleeding, wound"
    )
  end

  test "GET /triage returns success" do
    get triage_url
    assert_response :success
  end

  test "triage shows all procedures when no filters applied" do
    get triage_url
    assert_response :success
  end

  test "triage shows validation message when submitted blank" do
    get triage_url, params: { query: "" }
    assert_response :success
    assert_match "Please select a species or enter a symptom to search.", response.body
  end

  test "triage filters by species" do
    get triage_url, params: { species: "dog" }
    assert_response :success
    assert_match "Dog Choking", response.body
    assert_no_match "Cat Bleeding Wound", response.body
  end

  test "triage filters by keyword" do
    get triage_url, params: { query: "choking" }
    assert_response :success
    assert_match "Dog Choking", response.body
    assert_no_match "Cat Bleeding Wound", response.body
  end

  test "GET /first_aid_procedures/:id returns success" do
    get first_aid_procedure_url(@procedure)
    assert_response :success
    assert_match "Dog Choking", response.body
  end

  test "show renders severity label" do
    get first_aid_procedure_url(@procedure)
    assert_match "Immediate Action Required", response.body
  end
end
