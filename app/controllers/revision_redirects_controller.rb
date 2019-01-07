class RevisionRedirectsController < ApplicationController
  before_action :find_repository_details, :authorize, :only => [:edit, :update]

  def edit
  end

  def update
    # check if object exists
    if @redirect == nil || @redirect.new_record? then
      @redirect = RevisionRedirect.new(update_params)
      @redirect.repository_id = params[:id]

      # try to save new object to database
      if @redirect.save
        redirect_to settings_project_path(@project, :tab => 'repositories')
      else
        render :action => 'edit'
      end
    else
      # if it's not a new record, just update data
      if @redirect.update(update_params) then
        redirect_to settings_project_path(@project, :tab => 'repositories')
      else
        render :action => 'edit'
      end
    end
  end

  private

  def find_repository_details
    # find repository and redirect object
    @repository = Repository.find(params[:id])
    @redirect = RevisionRedirect.where(repository_id: params[:id]).first
    @project = @repository.project

    # get user domain to emulate git path (by default cgit path)
    user_domain = request.domain

    # if redirect cannot be found, create new with default values
    if not @redirect then
      @redirect = RevisionRedirect.new({
        revision_redirect: false,
        diff_redirect: false,
        repository_redirect: false,
        repository_id: params[:id],
        revision_link: "https://git.#{user_domain}/#{@project.identifier}/commit/?id=\%REV\%",
        diff_link: "https://git.#{user_domain}/#{@project.identifier}/diff/?id=\%DIFF\%",
        repository_link: "https://git.#{user_domain}/#{@project.identifier}"
      })
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def update_params
    params.require(:redirect).permit(
      :revision_redirect,
      :diff_redirect,
      :repository_redirect,
      :revision_link,
      :diff_link,
      :repository_link
    )
  end
end
