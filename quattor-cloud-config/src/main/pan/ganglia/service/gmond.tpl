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

unique template ganglia/service/gmond;

variable CONTENTS = <<EOF;
globals {
  daemonize = yes
  setuid = yes
  user = nobody
  debug_level = 0
  max_udp_msg_len = 1472
  mute = no
  deaf = no
  allow_extra_data = yes
  host_dmax = 0 /*secs */
  cleanup_threshold = 300 /*secs */
  gexec = no
  send_metadata_interval = 0 /*secs */
}

cluster {
EOF

variable CONTENTS = CONTENTS + ' name = "' + GANGLIA_CLUSTER_NAME + "\"\n";

variable CONTENTS = CONTENTS + <<EOF;
  owner = "unspecified"
  latlong = "unspecified"
  url = "unspecified"
}

host {
  location = "unspecified"
}

udp_send_channel {
EOF

variable CONTENTS = CONTENTS + ' host = ' + GANGLIA_MASTER + "\n";

variable CONTENTS = CONTENTS + <<EOF;
  port = 8649
  ttl = 1
}

udp_recv_channel {
  port = 8649
}

tcp_accept_channel {
  port = 8649
}

modules {
  module {
    name = "core_metrics"
  }
  module {
    name = "cpu_module"
    path = "modcpu.so"
  }
  module {
    name = "disk_module"
    path = "moddisk.so"
  }
  module {
    name = "load_module"
    path = "modload.so"
  }
  module {
    name = "mem_module"
    path = "modmem.so"
  }
  module {
    name = "net_module"
    path = "modnet.so"
  }
  module {
    name = "proc_module"
    path = "modproc.so"
  }
  module {
    name = "sys_module"
    path = "modsys.so"
  }
}

include ('/etc/ganglia/conf.d/*.conf')

collection_group {
  collect_once = yes
  time_threshold = 20
  metric {
    name = "heartbeat"
  }
}

collection_group {
  collect_once = yes
  time_threshold = 1200
  metric {
    name = "cpu_num"
    title = "CPU Count"
  }
  metric {
    name = "cpu_speed"
    title = "CPU Speed"
  }
  metric {
    name = "mem_total"
    title = "Memory Total"
  }
  metric {
    name = "swap_total"
    title = "Swap Space Total"
  }
  metric {
    name = "boottime"
    title = "Last Boot Time"
  }
  metric {
    name = "machine_type"
    title = "Machine Type"
  }
  metric {
    name = "os_name"
    title = "Operating System"
  }
  metric {
    name = "os_release"
    title = "Operating System Release"
  }
  metric {
    name = "location"
    title = "Location"
  }
}

collection_group {
  collect_once = yes
  time_threshold = 300
  metric {
    name = "gexec"
    title = "Gexec Status"
  }
}

collection_group {
  collect_every = 20
  time_threshold = 90
  metric {
    name = "cpu_user"
    value_threshold = "1.0"
    title = "CPU User"
  }
  metric {
    name = "cpu_system"
    value_threshold = "1.0"
    title = "CPU System"
  }
  metric {
    name = "cpu_idle"
    value_threshold = "5.0"
    title = "CPU Idle"
  }
  metric {
    name = "cpu_nice"
    value_threshold = "1.0"
    title = "CPU Nice"
  }
  metric {
    name = "cpu_aidle"
    value_threshold = "5.0"
    title = "CPU aidle"
  }
  metric {
    name = "cpu_wio"
    value_threshold = "1.0"
    title = "CPU wio"
  }
  metric {
    name = "cpu_intr"
    value_threshold = "1.0"
    title = "CPU intr"
  }
  metric {
    name = "cpu_sintr"
    value_threshold = "1.0"
    title = "CPU sintr"
  }
}

collection_group {
  collect_every = 20
  time_threshold = 90
  metric {
    name = "load_one"
    value_threshold = "1.0"
    title = "One Minute Load Average"
  }
  metric {
    name = "load_five"
    value_threshold = "1.0"
    title = "Five Minute Load Average"
  }
  metric {
    name = "load_fifteen"
    value_threshold = "1.0"
    title = "Fifteen Minute Load Average"
  }
}

collection_group {
  collect_every = 80
  time_threshold = 950
  metric {
    name = "proc_run"
    value_threshold = "1.0"
    title = "Total Running Processes"
  }
  metric {
    name = "proc_total"
    value_threshold = "1.0"
    title = "Total Processes"
  }
}

collection_group {
  collect_every = 40
  time_threshold = 180
  metric {
    name = "mem_free"
    value_threshold = "1024.0"
    title = "Free Memory"
  }
  metric {
    name = "mem_shared"
    value_threshold = "1024.0"
    title = "Shared Memory"
  }
  metric {
    name = "mem_buffers"
    value_threshold = "1024.0"
    title = "Memory Buffers"
  }
  metric {
    name = "mem_cached"
    value_threshold = "1024.0"
    title = "Cached Memory"
  }
  metric {
    name = "swap_free"
    value_threshold = "1024.0"
    title = "Free Swap Space"
  }
}

collection_group {
  collect_every = 40
  time_threshold = 300
  metric {
    name = "bytes_out"
    value_threshold = 4096
    title = "Bytes Sent"
  }
  metric {
    name = "bytes_in"
    value_threshold = 4096
    title = "Bytes Received"
  }
  metric {
    name = "pkts_in"
    value_threshold = 256
    title = "Packets Received"
  }
  metric {
    name = "pkts_out"
    value_threshold = 256
    title = "Packets Sent"
  }
}

collection_group {
  collect_every = 1800
  time_threshold = 3600
  metric {
    name = "disk_total"
    value_threshold = 1.0
    title = "Total Disk Space"
  }
}

collection_group {
  collect_every = 40
  time_threshold = 180
  metric {
    name = "disk_free"
    value_threshold = 1.0
    title = "Disk Space Available"
  }
  metric {
    name = "part_max_used"
    value_threshold = 1.0
    title = "Maximum Disk Space Used"
  }
}

EOF

'/software/components/filecopy/services' =
  npush(escape('/etc/ganglia/gmond.conf'),
        nlist('config', CONTENTS,
              'owner', 'root',
              'perms', '0644',
        ));

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service/gmond/on' = '';
'/software/components/chkconfig/service/gmond/startstop' = true;


