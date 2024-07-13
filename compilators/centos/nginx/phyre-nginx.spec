Name:           turbo-nginx
Version:        1.25.5
Release:        1%{?dist}
Summary:       Turbo Nginx - Web server for TurboPanel

License:       GPL
URL:    https://turbopanel.com
Source0: https://nginx.org/download/nginx-1.25.5.tar.gz
Source1: logrotate
Source2: nginx.conf
Source3: nginx.default.conf
Source4: nginx.service
Source5: nginx.upgrade.sh
Source6: nginx.suse.logrotate
Source7: nginx-debug.service
Source8: nginx.copyright
Source9: nginx.check-reload.sh

%description
Turbo Nginx is a web server for TurboPanel.

%prep
# we have no source, so nothing here

%build
tar -xzf $RPM_SOURCE_DIR/nginx-1.25.5.tar.gz -C $RPM_BUILD_DIR
cd nginx-1.25.5
./configure --prefix=/usr/local/turbo/nginx

%make_install
mv $RPM_BUILD_ROOT/usr/local/turbo/nginx/sbin/nginx $RPM_BUILD_ROOT/usr/local/turbo/nginx/sbin/turbo-nginx
rm -rf $RPM_BUILD_ROOT/usr/local/turbo/nginx/sbin/nginx.old
wget https://raw.githubusercontent.com/turbopaneldemo/turbopanelNGINX/main/compilators/debian/nginx/nginx.conf -O $RPM_BUILD_ROOT/usr/local/turbo/nginx/conf/nginx.conf

%files
/usr/local/turbo/nginx

%changelog
* Tue May 03 2024 Turbo Nginx Packaging <turbo-nginx-packaging@turbopanel.com> - 1.25.5-1%{?dist}.ngx
- 1.25.5-1
- Initial release of Turbo Nginx 1.25.5
