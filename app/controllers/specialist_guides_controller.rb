class SpecialistGuidesController < DocumentsController
  layout "specialist"
  before_filter :set_search_path

  def index
    params[:page] ||= 1
    params[:direction] = "alphabetical"
    @filter = Whitehall::DocumentFilter.new(all_specialist_guides, params)
    respond_to do |format|
      format.html
      format.json do
        render json: SpecialistGuideFilterJsonPresenter.new(@filter)
      end
    end
  end

  def show
    @topics = @document.topics
    render action: "show"
  end

  def search
    @search_term = params[:q]
    mainstream_results = Whitehall.mainstream_search_client.search(@search_term)
    @mainstream_results = mainstream_results.take(5)
    @more_mainstream_results = mainstream_results.length > 5
    @results = Whitehall.search_client.search(@search_term, 'specialist_guidance').take(50 - @mainstream_results.length)
    @total_results = @results.length + @mainstream_results.length
    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  def autocomplete
    render text: Whitehall.search_client.autocomplete(params[:q], 'specialist_guidance')
  end

private
  def document_class
    SpecialistGuide
  end

  def all_specialist_guides
    SpecialistGuide.published.includes(:document, :organisations, :topics)
  end

  def set_search_path
    response.headers[Slimmer::SEARCH_PATH_HEADER] = search_specialist_guides_path
  end

  def set_proposition
    set_slimmer_headers(proposition: "specialist")
  end

end
