require_dependency 'repositories_controller'

module RevisionRepositoriesPatch
  def self.included(base)
    base.send(:include, RevisionRepositoriesInstanceMethods)

    base.class_eval do
      unloadable
      before_action :destroy_revision_redirects, :only => [:destroy]
      before_action :repository_instant_redirect, :only => [:show]
    end
  end
end

module RevisionRepositoriesInstanceMethods
  def destroy_revision_redirects
    redirect = RevisionRedirect.where(repository_id: params[:id]).first
    redirect.destroy if request.delete?
  end

  def repository_instant_redirect
    redirect = RevisionRedirect.where(repository_id: @repository.id).first
    if redirect != nil && redirect.repository_redirect == true then
      redirect_to redirect.repository_link
    end
    false
  end
end
