require 'test_helper'
require 'gds_api/test_helpers/publishing_api'

class PublishingApiEditionWorkerTest < ActiveSupport::TestCase
  include GdsApi::TestHelpers::PublishingApi

  test "registers an edition with the publishing api" do
    edition = create(:published_detailed_guide)
    presenter = PublishingApiPresenters::Edition.new(edition)
    stub_publishing_api_put_item(presenter.base_path, presenter.as_json)

    PublishingApiEditionWorker.new.perform(edition.id)

    assert_publishing_api_put_item(presenter.base_path,
      JSON.parse(presenter.as_json.to_json))
  end

  test "registers case studies with their own presenter" do
    edition = create(:published_case_study)
    presenter = PublishingApiPresenters::CaseStudy.new(edition)
    stub_publishing_api_put_item(presenter.base_path, presenter.as_json)

    PublishingApiEditionWorker.new.perform(edition.id)

    assert_publishing_api_put_item(presenter.base_path,
      JSON.parse(presenter.as_json.to_json))
  end
end
