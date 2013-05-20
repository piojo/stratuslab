# ${BUILD_INFO}
#
# Created as part of the StratusLab project (http://stratuslab.eu)
#
# Copyright (c) 2010-2011, Centre National de la Recherche Scientifique
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

unique template config/stratuslab/benchmarks;

'/software/packages'=pkg_repl('blas-devel','3.2.2-2.fc14','x86_64');
'/software/packages'=pkg_repl('environment-modules','3.2.7b-7.fc13','x86_64');
'/software/packages'=pkg_repl('plpa-libs','1.3.2-4.fc13','x86_64');
'/software/packages'=pkg_repl('plpa-libs','1.3.2-4.fc13','i686');
'/software/packages'=pkg_repl('gcc-gfortran','4.5.1-4.fc14','x86_64');
'/software/packages'=pkg_repl('gcc','4.5.1-4.fc14','x86_64');

# Initial dependencies.
#'/software/packages'= pkg_repl( 'openmpi'       , '1.4.1-6.fc14'  , 'i386'   );
#'/software/packages'= pkg_repl( 'openmpi-devel' , '1.4.1-6.fc14'  , 'i386'   );
'/software/packages' = pkg_repl( 'openmpi'       , '1.4.1-6.fc14'  , 'x86_64' );
'/software/packages' = pkg_repl( 'openmpi-devel' , '1.4.1-6.fc14'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'lapack'        , '3.2.2-2.fc14'  , 'i386'   );
#'/software/packages'= pkg_repl( 'lapack-devel'  , '3.2.2-2.fc14'  , 'i386'   );
'/software/packages' = pkg_repl( 'lapack'        , '3.2.2-2.fc14'  , 'x86_64' );
'/software/packages' = pkg_repl( 'lapack-devel'  , '3.2.2-2.fc14'  , 'x86_64' );

# Additional dependencies.
#'/software/packages'= pkg_repl( 'blas'          , '3.2.2-2.fc14'  , 'i386'   );
'/software/packages' = pkg_repl( 'blas'          , '3.2.2-2.fc14'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'libgfortran'   , '4.5.1-4.fc14'  , 'i386'   );
'/software/packages' = pkg_repl( 'libgfortran'   , '4.5.1-4.fc14'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'libgomp'       , '4.5.1-4.fc14'  , 'i386'   );
'/software/packages' = pkg_repl( 'libgomp'       , '4.5.1-4.fc14'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'libibcm'       , '1.0.5-2.fc13'  , 'i386'   );
'/software/packages' = pkg_repl( 'libibcm'       , '1.0.5-2.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'libibverbs'    , '1.1.3-4.fc13'  , 'i386'   );
'/software/packages' = pkg_repl( 'libibverbs'    , '1.1.3-4.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'libnes'        , '0.9.0-2.el5'   , 'i386'   );
#'/software/packages'= pkg_repl( 'libnes'        , '0.9.0-2.el5'   , 'x86_64' );
#'/software/packages'= pkg_repl( 'librdmacm'     , '1.0.10-3.fc14' , 'i386'   );
'/software/packages' = pkg_repl( 'librdmacm'     , '1.0.10-3.fc14' , 'x86_64' );
#'/software/packages'= pkg_repl( 'mpi-selector'  , '1.0.2-1.el5'   , 'noarch' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'i386'   );
'/software/packages' = pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'openib'        , '1.4.1-5.el5'   , 'noarch' );
#'/software/packages'= pkg_repl( 'openmpi-libs'  , '1.4-4.el5'     , 'i386'   );
#'/software/packages'= pkg_repl( 'openmpi-libs'  , '1.4-4.el5'     , 'x86_64' );


'/software/packages' = pkg_repl( 'dhcp'          , '4.2.0-6.fc14'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
#'/software/packages'= pkg_repl( 'numactl'       , '2.0.3-8.fc13'  , 'x86_64' );
