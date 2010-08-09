################################################################################
#
# VERSION:    @VERSION@, @DATE@
# AUTHOR:     @AUTHOR@
# MAINTAINER: @MAINTAINER@
# LICENSE:    @LICENSE@
#
################################################################################
# Coding style: emulate <TAB> characters with 4 spaces, thanks!
################################################################################
declaration template components/@COMP@/schema;

include {'quattor/schema'};

include {'pan/types'};

type structure_daemon = {
    'HOST_MONITORING_INTERVAL' : long(1..) = 600
    'VM_POLLING_INTERVAL' : long(0..) = 600
    'VM_DIR' : string
    'PORT' : port = 2633
    'VNC_BASE_PORT' : port = 5000
    'DEBUG_LEVEL' : long(0..3) = 3
};

type structure_db = {
    'backend' : string = 'sqlite' with match(SELF, 'sqlite|mysql')
    'server' ? string
    'user' ? string
    'passwd' ? string
    'db_name' ? string
} with {
    SELF['backend'] != 'mysql' ||
      (
        defined(SELF['server']) &&
        defined(SELF['user']) &&
        defined(SELF['passwd']) &&
        defined(SELF['db_name'])
      )
};

type structure_one_network = {
    'NETWORK_SIZE' : long(1..) = 254
    'MAC_PREFIX' : string = '02:00' with match(SELF, '[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]')
};

type structure_image_repos = {
    'IMAGE_REPOSITORY_PATH' : string
    'DEFAULT_IMAGE_TYPE' : string = 'OS' with match(SELF, 'OS|CDROM|DATABLOCK')
    'DEFAULT_DEVICE_PREFIX' : string = 'hd' with match(SELF, 'hd|sd|xvd|vd')
};

type structure_mad = {
    'manager' : string with match(SELF, 'IM|VM|TM|HM|AUTHM')
    'executable' : string
    'arguments' : string
    'default' ? string
    'type' ? string with match(SELF, 'xen|kvm|xml')
} with {
    (SELF['manager'] == 'VM' && 
     defined(SELF['default']) &&
     defined(SELF['type']))
    ||
    (SELF['manager'] != 'VM' && 
     !defined(SELF['default']) &&
     !defined(SELF['type']))
};

type structure_hook = {
    'on' : string with match(SELF, 'CREATE|RUNNING|SHUTDOWN|STOP|DONE')
    'command' : string
    'arguments' : string
    'remote' : string = 'NO' with match(SELF, 'YES|NO')
};

type structure_component_@COMP@ = {
    include structure_component
    'location' : string = '/srv/cloud/one'
    'daemon' : structure_daemon = nlist()
    'db' : structure_db = nlist()
    'network' : structure_one_network = nlist()
    'image_repos' : structure_image_repos = nlist()
    'mads' : structure_mad{}
    'hooks' : structure_hook{}
};

bind '/software/components/@COMP@' = structure_component_@COMP@;