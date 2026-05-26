require "test_helper"

class AdminInstructionalVideosControllerTest < ActionDispatch::IntegrationTest
  def setup
    @procedure = FirstAidProcedure.create!(
      name: "Dog Choking",
      species: "dog",
      severity: "immediate",
      description: "A choking emergency.",
      symptom_keywords: "choking"
    )
    @step = @procedure.steps.create!(
      position: 1,
      instruction: "Open the mouth.",
      checklist: "Contact an emergency vet clinic immediately"
    )
  end

  def video_params(overrides = {})
    {
      title: "Dog Choking First Aid",
      url: "https://www.youtube.com/watch?v=abc123",
      description: "Demo video."
    }.merge(overrides)
  end

  test "admin can create procedure-level video" do
    assert_difference("InstructionalVideo.count", 1) do
      post admin_first_aid_procedure_instructional_videos_url(@procedure), params: {
        attach_to: "procedure",
        instructional_video: video_params
      }
    end

    video = InstructionalVideo.last
    assert_redirected_to admin_first_aid_procedure_url(@procedure)
    assert_equal @procedure, video.first_aid_procedure
    assert_nil video.step
  end

  test "admin can create step-level video without also attaching it to the procedure" do
    assert_difference("InstructionalVideo.count", 1) do
      post admin_first_aid_procedure_instructional_videos_url(@procedure), params: {
        attach_to: "step",
        instructional_video: video_params(step_id: @step.id)
      }
    end

    video = InstructionalVideo.last
    assert_redirected_to admin_first_aid_procedure_url(@procedure)
    assert_nil video.first_aid_procedure
    assert_equal @step, video.step
  end

  test "admin can update step-level video" do
    video = InstructionalVideo.create!(
      step: @step,
      title: "Old title",
      url: "https://www.youtube.com/watch?v=abc123"
    )

    patch admin_first_aid_procedure_instructional_video_url(@procedure, video), params: {
      attach_to: "step",
      instructional_video: video_params(title: "Updated title", step_id: @step.id)
    }

    assert_redirected_to admin_first_aid_procedure_url(@procedure)
    assert_equal "Updated title", video.reload.title
    assert_nil video.first_aid_procedure
    assert_equal @step, video.step
  end

  test "admin can delete video belonging to this procedure" do
    video = InstructionalVideo.create!(
      first_aid_procedure: @procedure,
      title: "Dog video",
      url: "https://www.youtube.com/watch?v=abc123"
    )

    assert_difference("InstructionalVideo.count", -1) do
      delete admin_first_aid_procedure_instructional_video_url(@procedure, video)
    end

    assert_redirected_to admin_first_aid_procedure_url(@procedure)
  end

  test "admin cannot attach video to a step from another procedure" do
    other = FirstAidProcedure.create!(
      name: "Cat Wound",
      species: "cat",
      severity: "immediate",
      description: "A wound emergency.",
      symptom_keywords: "bleeding"
    )
    other_step = other.steps.create!(position: 1, instruction: "Apply pressure.")

    assert_no_difference("InstructionalVideo.count") do
      post admin_first_aid_procedure_instructional_videos_url(@procedure), params: {
        attach_to: "step",
        instructional_video: video_params(step_id: other_step.id)
      }
    end
    assert_response :not_found
  end
end
