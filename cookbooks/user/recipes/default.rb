user_account 'focus' do
  comment   'Focus dev account'
  home      '/home/focus'
  shell     '/bin/bash'
end

## config sudo to run sudo without password
template "/etc/sudoers.d/focus-init-users" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :sudoers_groups => node['sudo']['groups'],
    :sudoers_users => node['sudo']['users'],
    :passwordless => node['sudo']['passwordless'],
  )
end
