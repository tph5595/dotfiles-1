# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Install this crontab with: whenever -f schedule.rb -w

every 10.minutes do
  # Fetch all remotes for indexed git repos, and fast-forward if possible
  command "git_index --update-all"
end

every 10.minutes do
  # Update dotfiles
  # - Set up new symlinks
  # - Update generated bashrc, git config, etc.
  # - Update this cron task
  command "cd $DOTFILES_PATH && (./setup/symlinks.sh; ./setup/bashrc.sh; ./setup/git_config.sh; whenever -f schedule.rb -w)"
end

# Update Travis CI build statuses for current branch of indexed git repos
every 3.minutes do
  command "git_index --batch-cmd update_travis_ci_status"
end

# Update Travis CI build statuses for all branches of indexed git repos
every 30.minutes do
  command "export UPDATE_ALL_BRANCHES=true && git_index --batch-cmd update_travis_ci_status"
end

# Rebuild SCM Breeze index
every 1.minute do
  command "git_index --rebuild"
end
