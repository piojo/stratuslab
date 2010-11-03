# ${BUILD_INFO} 
#
# Created as part of the StratusLab project (http://stratuslab.eu)
#
# Copyright (c) 2010, Centre Nationale de la Recherche Scientifique
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unique template one/service/parameters;

#
# Full hostname of NFS server, usually OpenNebula front-end.
#
variable ONE_NFS_SERVER = 'onehost-172.lal.in2p3.fr';

#
# An NFS wildcard that includes all of the OpenNebula nodes.
#
variable ONE_NFS_WILDCARD = '134.158.73.0/24';

#
# Monitoring internal in seconds.  Increase this value for
# a production system.
#
variable ONE_MONITOR_INTERVAL = 30;

#
# VM polling interval in seconds.  Increase this value for
# a production system.
#
variable ONE_POLLING_INTERVAL = 30;

#
# Ganglia variables
#
variable GANGLIA_MASTER = '134.158.73.172';
variable GANGLIA_CLUSTER_NAME = 'StratusLab';