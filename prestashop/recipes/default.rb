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
      (File.exists?("#{deploy[:deploy_to]}/shared/config") && !File.exists?("#{deploy[:deploy_to]}/shared/config")) || node[:deploy][:override_settings]
    end
  end

  # link to config
  link "#{deploy[:deploy_to]}/current/config/settings.inc.php" do
    to "#{deploy[:deploy_to]}/shared/config/settings.inc.php"
  end

  app_root = "#{deploy[:deploy_to]}/current"
  %w{ cache modules translations upload download config mails themes }.each do |folder|
    execute "chmod -R 777 #{app_root}/#{folder}" do
    end
  end
  execute "chmod 666 #{app_root}/.htaccess" do
  end
end