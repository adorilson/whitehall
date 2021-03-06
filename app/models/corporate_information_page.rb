class CorporateInformationPage < Edition
  include ::Attachable
  include Searchable

  has_one :edition_organisation, foreign_key: :edition_id, dependent: :destroy
  has_one :organisation, include: :translations, through: :edition_organisation, autosave: false
  has_one :edition_worldwide_organisation, foreign_key: :edition_id, dependent: :destroy
  has_one :worldwide_organisation, through: :edition_worldwide_organisation, autosave: false

  delegate :slug, :display_type_key, to: :corporate_information_page_type

  add_trait do
    def process_associations_before_save(new_edition)
      if @edition.organisation
        new_edition.organisation = @edition.organisation
      elsif @edition.worldwide_organisation
        new_edition.worldwide_organisation = @edition.worldwide_organisation
      end
    end
  end
  delegate :alternative_format_contact_email, :acronym, to: :owning_organisation

  validates :corporate_information_page_type_id, presence: true
  validate :only_one_organisation_or_worldwide_organisation

  before_save :ensure_title_is_blank
  def ensure_title_is_blank
    self.title = ''
  end

  def body_required?
    !about_page?
  end

  def search_title
    title_prefix_organisation_name
  end

  def search_index
    super.merge("organisations" => [owning_organisation.slug])
  end

  def self.search_only
    # Ensure only CIPs associated with a live Organisation are indexed in search.
    super.joins(:organisation).where(organisations: {govuk_status: "live"})
  end

  def title_required?
    false
  end

  def only_one_organisation_or_worldwide_organisation
    if organisation && worldwide_organisation
      errors.add(:base, "Only one organisation or worldwide organisation allowed")
    end
  end

  def skip_organisation_validation?
    true
  end

  def display_type
    "Corporate information"
  end

  def translatable?
    !non_english_edition?
  end

  def owning_organisation
    organisation || worldwide_organisation
  end

  def organisations
    [owning_organisation]
  end

  def sorted_organisations
    organisations
  end

  def self.for_slug(slug)
    if type = CorporateInformationPageType.find(slug)
      find_by_corporate_information_page_type_id(type.id)
    end
  end

  def self.for_slug!(slug)
    if type = CorporateInformationPageType.find(slug)
      find_by_corporate_information_page_type_id!(type.id)
    end
  end

  def corporate_information_page_type
    CorporateInformationPageType.find_by_id(corporate_information_page_type_id)
  end

  def corporate_information_page_type=(type)
    self.corporate_information_page_type_id = type && type.id
  end

  def title_prefix_organisation_name
    [owning_organisation.name, title].join(" \u2013 ")
  end

  def title(locale = :en)
    corporate_information_page_type.title(owning_organisation)
  end

  def self.by_menu_heading(menu_heading)
    type_ids = CorporateInformationPageType.by_menu_heading(menu_heading).map(&:id)
    where(corporate_information_page_type_id: type_ids)
  end

  def summary_required?
    false
  end

  def about_page?
    corporate_information_page_type.try(:slug) == 'about'
  end

  private

  def string_for_slug
    nil
  end
end
