#   Copyright [2018] [Sunayu LLC]
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# CAT2

# Required package for augeas
CAT2 sssd augeas required pkg:
  pkg.installed:
  - name: python-augeas

sssd package:
  pkg.installed:
  - name: sssd
  - watch_in:
    - service: sssd restart service

# RHEL-07-041002
sssd initialize sssd.conf:
  file.managed:
  - name: /etc/sssd/sssd.conf
  - mode: 0600
  - contents:
    - '[sssd]'
    - domains = LOCAL
    - services = nss, pam
    - config_file_version = 2
    - ''
    - '[ssh]'
    - ssh_known_hosts_timeout = 86400
    - ''
    - '[nss]'
    - filter_groups = root
    - filter_users = root
    - memcache_timeout = 86400
    - ''
    - '[domain/LOCAL]'
    - id_provider = local
    - auth_provider = local
    - access_provider = permit
    - ''
    - '[pam]'
    - offline_credentials_expiration = 1
    - offline_failed_login_attempts = 3
    - offline_failed_login_delay = 30
  - replace: false
  - watch_in:
    - service: sssd restart service

# CAT2
# RHEL-07-010400
CAT2 RHEL-07-010400 sssd.conf nss memcache_timeout:
  augeas.change:
  - lens: sssd
  - context: /files/etc/sssd/sssd.conf
  - changes:
    - set "target[. = 'nss']/memcache_timeout" 86400
  - watch_in:
    - service: sssd restart service

# CAT2
# RHEL-07-010401
CAT2 RHEL-07-010401 sssd.conf pam offline_credentials_expiration:
  augeas.change:
  - context: /files/etc/sssd/sssd.conf
  - changes:
    - set "target[. = 'pam']/offline_credentials_expiration" 1
  - watch_in:
    - service: sssd restart service

# CAT2
# RHEL-07-010402
CAT2 RHEL-07-010402 sssd.conf ssh ssh_known_hosts_timeout:
  augeas.change:
  - context: /files/etc/sssd/sssd.conf
  - changes:
    - set "target[. = 'ssh']/ssh_known_hosts_timeout" 86400
  - watch_in:
    - service: sssd restart service

sssd restart service:
  service.running:
  - name: sssd
