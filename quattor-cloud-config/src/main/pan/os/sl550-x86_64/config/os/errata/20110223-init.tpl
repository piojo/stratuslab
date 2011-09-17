unique template config/os/errata/20110223-init;

variable OS_KERNEL_VERSION_ERRATA ?= nlist(
  'sl550', '2.6.18-238.1.1.el5',
);

# Because JAVA is updated, define a new DEFAULT version to be configured
variable JAVA_JDK_DEFAULT_VERSION ?= '1.6.0_24';