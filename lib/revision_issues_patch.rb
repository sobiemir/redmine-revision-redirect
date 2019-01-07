require_dependency 'issues_controller'

module RevisionIssuesPatch
  def self.included(base)
    base.send(:include, RevisionIssuesInstanceMethods)

    base.class_eval do
      unloadable
      before_action :get_revision_redirects, :only => [:show]
    end
  end
end

module RevisionIssuesInstanceMethods
  def get_revision_redirects
    @redirects = Hash.new do |hash, key|
      hash[key] = RevisionRedirect.where(repository_id: key).first
    end
  end
end
