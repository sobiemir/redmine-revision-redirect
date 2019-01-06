class RevisionRedirectsController < ApplicationController
  before_action :authorize
  before_action :find_repository_details, :only => [:edit, :update]

  def edit
  end

  def update
    if @redirect.new_record? then
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
    @repository = Repository.find(params[:id])
    @redirect = RevisionRedirect.where(repository_id: params[:id]).first
    @project = @repository.project

    # if redirect cannot be found, create new with default values
    if not @redirect then
      @redirect = RevisionRedirect.new({
        revision_redirect: false,
        diff_redirect: false,
        repository_redirect: false,
        repository_id: params[:id],
        revision_link: "https://git.example.com/#{@project.identifier}/commit/?id=\%REV\%",
        diff_link: "https://git.example.com/#{@project.identifier}/diff/?id=\%DIFF\%",
        repository_link: "https://git.example.com/#{@project.identifier}"
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
