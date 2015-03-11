node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/settings.inc.php" do
    source 'settings.inc.php.erb'
    mode '0770'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
    )
    only_if do
      (FileTest.exists?("#{deploy[:deploy_to]}/shared/config") && !FileTest.exists?("#{deploy[:deploy_to]}/shared/config/settings.inc.php")) || node[:deploy][:override_settings]
    end
  end

  # link to config
  link "#{deploy[:deploy_to]}/current/config/settings.inc.php" do
    to "#{deploy[:deploy_to]}/shared/config/settings.inc.php"
    owner deploy[:user]
    group deploy[:group]
  end

  # link to aws/img
  execute "rm -rf #{deploy[:deploy_to]}/current/img" do
  end
  link "#{deploy[:deploy_to]}/current/img" do
    to "/mnt/aws/img"
    owner deploy[:user]
    group deploy[:group]
  end

  # execute "mkdir -p /mnt/aws/themes/bootstrap-theme/"

  # link to aws/theme
  # link "#{deploy[:deploy_to]}/current/themes/bootstrap-theme/cache" do
  #   to "/mnt/aws/themes/bootstrap-theme/cache"
  #   owner deploy[:user]
  #   group deploy[:group]
  # end

  # execute "rm -rf /mnt/aws/themes/bootstrap-theme/"

  # assets
  # execute "cp -R #{deploy[:deploy_to]}/current/themes/bootstrap-theme/assets/ /mnt/aws/themes/bootstrap-theme/" do
  end

  app_root = "#{deploy[:deploy_to]}/current"
  execute "chmod -R 770 #{app_root}" do
  end

  %w{ cache modules translations upload download config mails themes tools }.each do |folder|
    execute "chmod -R 777 #{app_root}/#{folder}" do
    end
  end
  execute "chmod 666 #{app_root}/.htaccess" do
  end
  execute "chmod 666 #{app_root}/robots.txt" do
  end
end
