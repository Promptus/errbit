namespace :deploy do
  
  desc "deploy to production server"
  task :production do
    branch = ENV['BRANCH'] || 'master'
    cmds = [
      'source /etc/profile.d/rvm.sh',
      'cd /var/www/errbit',
      "git fetch && git reset --hard origin/#{branch}",
      'bundle install --deployment --without test development'
    ]
    cmds << 'RAILS_ENV=production bundle exec rake db:migrate' unless %w(0 f false n no).include?(ENV['M'])
    cmds << 'RAILS_ENV=production bundle exec rake assets:precompile' unless %w(0 f false n no).include?(ENV['PC'])
    cmds << '/etc/init.d/errbit restart'

    system "ssh deploy@errbit.promptus-partners.de '#{ cmds.join ';' }'"
  end
end

desc "deploy to production server"
task :deploy => ["deploy:production"]
