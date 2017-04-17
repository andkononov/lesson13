node default {
  include nginx_install
  include mysql_install
  notify { 'Mission Complete':} 
}
