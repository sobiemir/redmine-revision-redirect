require_dependency 'repositories_controller'

module RevisionRepositoriesPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      before_action :destroy_revision_redirects, :only => [:destroy]
    end
  end
end

module InstanceMethods
  def destroy_revision_redirects
    redirect = RevisionRedirect.where(repository_id: params[:id]).first
    redirect.destroy if request.delete?
  end
end
