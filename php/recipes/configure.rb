node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/settings.inc.php" do
    cookbook 'php'
    source 'settings.inc.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
      # :memcached => deploy[:memcached],
      # :layers => node[:opsworks][:layers],
      # :stack_name => node[:opsworks][:stack][:name]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  # link to config
  link "#{deploy[:deploy_to]}/current/config/settings.inc.php" do
    to "#{deploy[:deploy_to]}/shared/config/settings.inc.php"
  end
end
