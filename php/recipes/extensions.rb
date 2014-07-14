include_recipe "apt"

node[:php][:extensions].each do | pkg |
  package pkg do
    action :install
  end
end