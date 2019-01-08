# Redmine Revision Redirect

This plugin helps with redirects for revisions in commit history for issue.

## About plugin

[Redmine](https://www.redmine.org) has support for repositories, but his original repository browser is slow, especially while browsing revisions.  
This works fine if you don't care about efficiency and if you don't have own repository browser, for example [cgit](https://git.zx2c4.com/cgit/), [gitlab](https://about.gitlab.com), etc...

Redmine has really great integration with repositories and revisions, but we need to configure it properly.  
If we do this, we get two systems, connected with each other, that do what they were created for and what they do best.  
Description of this plugin assumes, that you're using [git](https://git-scm.com) repository, but you can use it with whatever repository redmine supports.

## Prepare

Before installing plugin, we need to prepare required data on our serwer.  
If you have repositories and redmine on same server, you can skip this point, because it describes how to make mirror of Git repository to work with redmine.  
Anyway, you still may need to setup crone for fetching repository changesets in redmine.

### Repository

Before we start with the [Redmine Revision Redirect](https://www.git.aculo.pl/redmine-revision-redirect/) plugin, we need to prepare repositories, that will be connected with Redmine.  
For this we need to login as user, that runs redmine and create a directory, that will store our repositories.  
This example assumes, that you have user with name `redmine`, and his home is in `/home/redmine` directory.

    $ sudo su - redmine
    $ cd /home/redmine
    $ mkdir repos
    $ cd repos

When we do this, we shoud be able to mirror repository that we are interested in.  
Here we try to mirror of the Moss repository.

    $ git clone --bare https://github.com/sobiemir/moss.git

Then, using your favourite text editor, open `config` file placed in your `moss.git` directory.  
To the `remote "origin"` section, right after `url` entry, add following lines:

    fetch = +refs/*:refs/*
    mirror = true

This lines allow you to create mirror repository for all branches, as you will see, it will be useful in next section.

### Cron

If you create mirror of repository, it won't update automatically when you push new changes to `origin`.  
Cron is one of the options to do it automatically by system.  
First of all you need to add new entry in `cron` placed in `/etc/crontab`.

    */5 * * * * redmine cd /home/redmine/repos/moss.git && git fetch -q --all -p

It tells the system to run `git fetch -q --all -p` command as user `redmine` inside `moss` repository folder.  
This command allow to update repository and remove all branches that was removed in `origin` by user.  
You could also place this entry in your custom file, created inside `/etc/cron.d` directory.  

Updating the repository is unfortunately not enough, because system should update also redmine database.  
Redmine is storing all revisions in database, because for example this allows to create faster relation between repository revisions and our project issues.  

To update also redmine database, we need to add new command to the `crontab` file or alter it with `&&` to the entry, that was presented before.

    ruby bin/rails runner "Repository.fetch_changesets" -e production

This command do the trick and fetch repository changesets in redmine database.

## Configuration

After prepare steps, we should be able to install and configure plugin to work with your redmine instance.

### Installation

Installation of this plugin consist of two steps.  
First, we need to clone repository of [Redmine Revision Redirect](https://www.git.aculo.pl/redmine-revision-redirect/) plugin, by using `git clone` command inside plugins directory, located directly inside your redmine instance.

    git clone https://github.com/sobiemir/redmine-revision-redirect redmine_revision_redirect

It is important to set folder name for plugin right after url to `redmine_revision_redirect`.  
In second step we need to run migrations by using `rake` command inside redmine directory:

    bundle exec rake redmine:plugins:migrate

This command will create new table in database, in which will be stored information about redirects.  
At this point we will finish our adventure with terminal and open our redmine website.

### Repositories

In your project settings you should be able to add new repository, by opening repository tab.

![Creating new repository in Redmine](https://img.aculo.pl/redmine-revision-redirect/create-repository.png)

Path to repository is path, that we have our `moss.git` folder, in this example it's `/home/redmine/repos/moss.git`.  
Redmine supports also multiple repositories for single project, so, you can add more than one.  
Anyway, after repository create, you will be redirected to list of repositories, assigned to project.  

![Creating new repository in Redmine](https://img.aculo.pl/redmine-revision-redirect/repository-menu.png)

This list will have additional link in actions on right side, named redirects.

### Redirects

When we click on redirects link in action menu from repository list, we get new form with fields for redirects.

![Creating new repository in Redmine](https://img.aculo.pl/redmine-revision-redirect/repository-redirects.png)

Here we can define what we want to redirect.  
Revision redirect is redirect, that works when we click on revision number in issue.  
Diffstat is usually placed next to revision number (it's not always visible).  

![Creating new repository in Redmine](https://img.aculo.pl/redmine-revision-redirect/commit-history.png)

This redirects are visible in the image above, where in header of all commits in history, we have revision identifier and diff word that redirects us to diffstat.

![Creating new repository in Redmine](https://img.aculo.pl/redmine-revision-redirect/redirect-menu.png)

Repository redirect works when we click on repository tab in main menu, like in image above, or if we select one of the repository from side menu, like in image below.

![Creating new repository in Redmine](https://img.aculo.pl/redmine-revision-redirect/multi-repository.png)

When we have more than one repository, one of these must be main repository.  
Redirect for main repository means, that we cannot open repository tab from main menu (it automatically redirects to url, provided in field).  

If we don't have redirect in main repository, we should see list of repositories.  
When we click on repository that has enabled repository redirect, we will be redirected to the url, provided in field.
