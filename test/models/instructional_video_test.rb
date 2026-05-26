require "test_helper"

class InstructionalVideoTest < ActiveSupport::TestCase
  def setup
    @procedure = FirstAidProcedure.create!(
      name: "Dog Choking", species: "dog", severity: "immediate",
      description: "A choking emergency.", symptom_keywords: "choking"
    )
    @step = Step.create!(first_aid_procedure: @procedure, position: 1, instruction: "Open the mouth.")
  end

  def valid_video_for_procedure
    InstructionalVideo.new(
      first_aid_procedure: @procedure,
      title: "Heimlich for Dogs",
      url: "https://www.youtube.com/watch?v=abc123"
    )
  end

  test "valid procedure-level video saves successfully" do
    assert valid_video_for_procedure.valid?
  end

  test "valid step-level video saves successfully" do
    v = InstructionalVideo.new(step: @step, title: "Demo", url: "https://www.youtube.com/watch?v=xyz")
    assert v.valid?
  end

  test "title is required" do
    v = valid_video_for_procedure
    v.title = ""
    assert_not v.valid?
  end

  test "url is required" do
    v = valid_video_for_procedure
    v.url = ""
    assert_not v.valid?
  end

  test "url must start with http or https" do
    v = valid_video_for_procedure
    v.url = "ftp://invalid.com/video"
    assert_not v.valid?
    assert_includes v.errors[:url], "must start with http:// or https://"
  end

  test "video with neither procedure nor step is invalid" do
    v = InstructionalVideo.new(title: "Orphan", url: "https://www.youtube.com/watch?v=abc")
    assert_not v.valid?
    assert_includes v.errors[:base], "must be attached to a procedure or a step"
  end

  test "video attached to both procedure and step is invalid" do
    v = InstructionalVideo.new(
      first_aid_procedure: @procedure,
      step: @step,
      title: "Double attached",
      url: "https://www.youtube.com/watch?v=abc"
    )
    assert_not v.valid?
    assert_includes v.errors[:base], "cannot be attached to both a procedure and a step"
  end

  test "embed_url converts youtube watch url" do
    v = valid_video_for_procedure
    assert_equal "https://www.youtube.com/embed/abc123", v.embed_url
  end

  test "embed_url converts youtu.be url" do
    v = valid_video_for_procedure
    v.url = "https://youtu.be/abc123"
    assert_equal "https://www.youtube.com/embed/abc123", v.embed_url
  end

  test "embed_url returns url unchanged if already embed" do
    v = valid_video_for_procedure
    v.url = "https://www.youtube.com/embed/abc123"
    assert_equal "https://www.youtube.com/embed/abc123", v.embed_url
  end

  test "embed_url returns nil for unsupported url format" do
    v = valid_video_for_procedure
    v.url = "https://vimeo.com/12345"
    assert_nil v.embed_url
  end
end
