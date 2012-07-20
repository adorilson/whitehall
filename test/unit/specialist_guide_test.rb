require "test_helper"

class SpecialistGuideTest < ActiveSupport::TestCase
  test "should allow body to be paginated" do
    article = build(:specialist_guide)
    assert article.allows_body_to_be_paginated?
  end

  test "should be able to relate to topics" do
    article = build(:specialist_guide)
    assert article.can_be_associated_with_topics?
  end

  test "should have a summary" do
    assert build(:specialist_guide).has_summary?
  end

  test "can be related to another specialist guide" do
    related_guide = create(:specialist_guide)
    guide = create(:specialist_guide, latest_outbound_related_specialist_guides: [related_guide])
    assert_equal [related_guide], guide.reload.related_specialist_guides
  end

  test "relationships between guides work in both directions" do
    related_guide = create(:specialist_guide)
    guide = create(:specialist_guide, latest_outbound_related_specialist_guides: [related_guide])
    assert_equal [guide], related_guide.reload.related_specialist_guides
  end

  test "related specialist guides always returns latest edition of related document" do
    published_guide = create(:published_specialist_guide)
    guide = create(:specialist_guide, latest_outbound_related_specialist_guides: [published_guide])

    latest_edition = published_guide.create_draft(create(:policy_writer))
    assert_equal [latest_edition], guide.reload.related_specialist_guides
  end

  test "published related specialist guides returns latest published edition of related document" do
    published_guide = create(:published_specialist_guide)
    guide = create(:specialist_guide, latest_outbound_related_specialist_guides: [published_guide])

    latest_edition = published_guide.create_draft(create(:policy_writer))
    assert_equal [published_guide], guide.reload.published_related_specialist_guides
  end
end
