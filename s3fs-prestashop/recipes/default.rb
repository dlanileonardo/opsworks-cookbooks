node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  directory "/mnt/aws/themes/bootstrap-theme/cache/" do
    owner deploy[:user]
    group deploy[:group]
    mode 0777
    action :create
  end

  link "#{deploy[:deploy_to]}/current/theme/bootstrap-theme/cache" do
    to "/mnt/aws/themes/bootstrap-theme/cache/"
  end

  # Link img to S3
  # link "#{deploy[:deploy_to]}/current/img" do
  #   to "/mnt/aws/img"
  # end
end