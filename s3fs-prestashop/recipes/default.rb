node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  absolute_path = ""
  %w{ mnt aws themes bootstrap-theme cache }.each do | folder |
    absolute_path += "/#{folder}"
    directory absolute_path do
      owner deploy[:user]
      group deploy[:group]
      mode 0777
      action :create
      only_if do
        !File.exists?(absolute_path)
      end
    end
  end

  Link img to S3
  link "#{deploy[:deploy_to]}/current/img" do
    to "/mnt/aws/img"
    only_if do
      File.exists?("/mnt/aws/img") && !File.exists?("#{deploy[:deploy_to]}/current/img")
    end
  end
end