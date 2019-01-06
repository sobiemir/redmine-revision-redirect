class RevisionRedirectsController < ApplicationController
  before_action :find_repository_details, :only => [:edit, :update]

  def edit
  end

  def update
  end

  def find_repository_details
    @repository = Repository.find(params[:id])
    @redirect = RevisionRedirect.where(repository_id: params[:id]).first

    if not @redirect then
      @redirect = RevisionRedirect.new({
        revision_redirect: false,
        diff_redirect: false,
        repository_redirect: false,
        commiter_email: false,
        repository_id: params[:id],
        revision_link: "",
        diff_link: "",
        repository_link: ""
      })
    end

    @project = @repository.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # def update
  #   project = Project.find(params[:id])
  #   if params[:repository_id].present?
  #     repository = project.repositories.find_by_identifier_param(params[:repository_id])
  #   else
  #     repository = project.repository
  #   end
  #   (render_404; return false) unless repository
  #   path = params[:path].is_a?(Array) ? params[:path].join('/') : params[:path].to_s
  #   rev = params[:rev].blank? ? repository.default_branch : params[:rev].to_s.strip
  #   rev_to = params[:rev_to]

  #   unless rev.to_s.match(REV_PARAM_RE) && rev_to.to_s.match(REV_PARAM_RE)
  #     if repository.branches.blank?
  #       raise InvalidRevisionParam
  #     end
  #   end
  # rescue ActiveRecord::RecordNotFound
  #   render_404
  # rescue InvalidRevisionParam
  #   show_error_not_found
  # end

end
