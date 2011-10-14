class Policy < Document
  has_many :nation_applicabilities
  has_many :nations, through: :nation_applicabilities

  before_save :ensure_applicable_to_england

  private

  def ensure_applicable_to_england
    nations << Nation.england unless nations.include?(Nation.england)
  end
end