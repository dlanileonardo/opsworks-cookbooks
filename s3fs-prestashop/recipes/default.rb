node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  # directory "/mnt/themes/bootstrap-theme/cache" do
  #   owner deploy[:user]
  #   group deploy[:group]
  #   mode 0777
  #   action :create
  #   recursive: true
  # end

  # Link cache do tema
  link "#{deploy[:deploy_to]}/current/themes/bootstrap-theme/cache" do
    to "/mnt/themes/bootstrap-theme/cache"
    only_if do
      File.exists?("/mnt/themes/bootstrap-theme/cache") && !File.exists?("#{deploy[:deploy_to]}/current/themes/bootstrap-theme/cache")
    end
  end

  # Link img to S3
  link "#{deploy[:deploy_to]}/current/img" do
    to "/mnt/aws/img"
    only_if do
      File.exists?("/mnt/aws/img") && !File.exists?("#{deploy[:deploy_to]}/current/img")
    end
  end
end