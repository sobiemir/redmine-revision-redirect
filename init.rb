Redmine::Plugin.register :redmine_revision_redirect do
  name 'Redmine Revision Redirect plugin'
  author 'sobiemir'
  description 'This plugin redirects all revisions to external service with git repository.'
  version '0.1.0'
  url 'https://git.aculo.pl/redmine-revision-redirect'
  author_url 'https://aculo.pl'

  permission :edit_revision_redirects, :revision_redirects => [:edit, :update]
end

# add patches to controllers
Rails.configuration.to_prepare do
  RepositoriesController.send(:include, RevisionRepositoriesPatch)
  IssuesController.send(:include, RevisionIssuesPatch)
end
