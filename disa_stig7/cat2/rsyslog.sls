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

{% from "disa_stig7/map.jinja" import disa_stig7 with context %}

# CAT2
# RHEL-07-021160
CAT2 RHEL-07-021160 log cron rsyslog:
  file.replace:
  - name: /etc/rsyslog.conf
  - pattern: |
      ^cron\.\*.+$
  - repl: "cron.*                                                  /var/log/cron\n"
  - watch_in:
    - service: rsyslog service restart

# CAT2
# RHEL-07-030770
# RHEL-07-030780
# RHEL-07-031010
CAT2 RHEL-07-031010 rsyslog.d log server:
  file.managed:
  - name: /etc/rsyslog.d/log_server.conf
  - contents:
    - 'ModLoad imtcp'
    - '*.* @@{{ disa_stig7.log_server }}'
  - watch_in:
    - service: rsyslog service restart

# CAT2
# RHEL-07-040020
CAT2 RHEL-07-040020 rsyslog.d auth:
  file.managed:
  - name: /etc/rsyslog.d/auth.conf
  - contents:
    - 'auth.*,authpriv.* /var/log/auth.log'
  - watch_in:
    - service: rsyslog service restart

CAT2 RHEL-07-040020 rsyslog.d daemon:
  file.managed:
  - name: /etc/rsyslog.d/daemon.conf
  - contents:
    - 'daemon.notice /var/log/messages'
  - watch_in:
    - service: rsyslog service restart

rsyslog service restart:
  service.running:
  - name: rsyslog
