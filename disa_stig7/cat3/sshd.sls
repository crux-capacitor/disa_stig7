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

{% from "disa_stig7/sshd.sls" import set_sshd_conf %}

include:
  - disa_stig7.sshd

# CAT3
# RHEL-07-040530
{{ set_sshd_conf('CAT3','RHEL-07-040530','PrintLastLog','yes') }}
