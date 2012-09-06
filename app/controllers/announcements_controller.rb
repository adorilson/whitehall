class AnnouncementsController < PublicFacingController

  def index
    params[:page] ||= 1
    params[:direction] ||= "before"
    @filter = Whitehall::DocumentFilter.new(all_announcements, params)
    respond_to do |format|
      format.html
      format.json do
        render json: AnnouncementFilterJsonPresenter.new(@filter)
      end
      format.atom do
        @publications = @filter.documents.by_published_at
      end
    end
  end

private

  def all_announcements
    Announcement.published
      .includes(:document, :organisations)
  end

end
