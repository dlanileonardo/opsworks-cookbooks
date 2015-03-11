node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  # Link cache do tema
  link "#{deploy[:deploy_to]}/current/themes/#{node[:prestashop][:theme]}/cache" do
    to "/mnt/aws/themes/#{node[:prestashop][:theme]}/cache"
    only_if do
      FileTest.exists?("/mnt/themes/#{node[:prestashop][:theme]}/cache") && !FileTest.exists?("#{deploy[:deploy_to]}/current/themes/#{node[:prestashop][:theme]}/cache")
    end
  end

  # Link img to S3
  link "#{deploy[:deploy_to]}/current/img" do
    to "/mnt/aws/img"
    only_if do
      FileTest.exists?("/mnt/aws/img") && !FileTest.exists?("#{deploy[:deploy_to]}/current/img")
    end
  end

  # List of typefiles to S3 Sync
  template "#{deploy[:deploy_to]}/.pictures.s3cmd.includes" do
    mode 0755
    source 'pictures.s3cmd.includes'
    notifies :restart, "service[apache2]"
  end

  # Command to Sync
  execute "s3sync_themes" do
    cwd "#{deploy[:deploy_to]}/current/"
    command "s3cmd sync --exclude '*.*' --include-from #{deploy[:deploy_to]}.pictures.s3cmd.includes themes s3://omegajeans-static"
    action :run
  end

  execute "s3sync_modules" do
    cwd "#{deploy[:deploy_to]}/current/"
    command "s3cmd sync --exclude '*.*' --include-from #{deploy[:deploy_to]}.pictures.s3cmd.includes modules s3://omegajeans-static"
    action :run
  end
end
