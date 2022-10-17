
```bash
[bjorner@submit-1 ~]$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
--2021-07-02 13:30:23--  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
Resolving repo.anaconda.com (repo.anaconda.com)... 104.16.130.3, 104.16.131.3, 2606:4700::6810:8303, ...
Connecting to repo.anaconda.com (repo.anaconda.com)|104.16.130.3|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 94235922 (90M) [application/x-sh]
Saving to: ‘Miniconda3-latest-Linux-x86_64.sh’

100%[=================================================================================================>] 94,235,922   178MB/s   in 0.5s   

2021-07-02 13:30:24 (178 MB/s) - ‘Miniconda3-latest-Linux-x86_64.sh’ saved [94235922/94235922]

[bjorner@submit-1 ~]$ sh Miniconda3-latest-Linux-x86_64.sh

Welcome to Miniconda3 py38_4.9.2

In order to continue the installation process, please review the license
agreement.
Please, press ENTER to continue
>>> 
===================================
End User License Agreement - Anaconda Individual Edition
===================================

Copyright 2015-2020, Anaconda, Inc.

All rights reserved under the 3-clause BSD License:

This End User License Agreement (the "Agreement") is a legal agreement between you and Anaconda, Inc. ("Anaconda") and governs your use of 
Anaconda Individual Edition (which was formerly known as Anaconda Distribution).

Subject to the terms of this Agreement, Anaconda hereby grants you a non-exclusive, non-transferable license to:

  * Install and use the Anaconda Individual Edition (which was formerly known as Anaconda Distribution),
  * Modify and create derivative works of sample source code delivered in Anaconda Individual Edition from Anaconda's repository; and
  * Redistribute code files in source (if provided to you by Anaconda as source) and binary forms, with or without modification subject to 
the requirements set forth below.

Anaconda may, at its option, make available patches, workarounds or other updates to Anaconda Individual Edition. Unless the updates are pr
ovided with their separate governing terms, they are deemed part of Anaconda Individual Edition licensed to you as provided in this Agreeme
nt.  This Agreement does not entitle you to any support for Anaconda Individual Edition.

Anaconda reserves all rights not expressly granted to you in this Agreement.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are m
et:

  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the d
ocumentation and/or other materials provided with the distribution.
  * Neither the name of Anaconda nor the names of its contributors may be used to endorse or promote products derived from this software wi
thout specific prior written permission.

You acknowledge that, as between you and Anaconda, Anaconda owns all right, title, and interest, including all intellectual property rights
, in and to Anaconda Individual Edition and, with respect to third-party products distributed with or through Anaconda Individual Edition, 
the applicable third-party licensors own all right, title and interest, including all intellectual property rights, in and to such products
.  If you send or transmit any communications or materials to Anaconda suggesting or recommending changes to the software or documentation,
 including without limitation, new features or functionality relating thereto, or any comments, questions, suggestions or the like ("Feedba
ck"), Anaconda is free to use such Feedback. You hereby assign to Anaconda all right, title, and interest in, and Anaconda is free to use, 
without any attribution or compensation to any party, any ideas, know-how, concepts, techniques or other intellectual property rights conta
ined in the Feedback, for any purpose whatsoever, although Anaconda is not required to use any Feedback.

THIS SOFTWARE IS PROVIDED BY ANACONDA AND ITS CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, TH
E IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ANACONDA BE LIABLE FOR ANY D
IRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS O
R SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, ST
RICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSS
IBILITY OF SUCH DAMAGE.

TO THE MAXIMUM EXTENT PERMITTED BY LAW, ANACONDA AND ITS AFFILIATES SHALL NOT BE LIABLE FOR ANY SPECIAL, INCIDENTAL, PUNITIVE OR CONSEQUENT
IAL DAMAGES, OR ANY LOST PROFITS, LOSS OF USE, LOSS OF DATA OR LOSS OF GOODWILL, OR THE COSTS OF PROCURING SUBSTITUTE PRODUCTS, ARISING OUT
 OF OR IN CONNECTION WITH THIS AGREEMENT OR THE USE OR PERFORMANCE OF ANACONDA INDIVIDUAL EDITION, WHETHER SUCH LIABILITY ARISES FROM ANY C
LAIM BASED UPON BREACH OF CONTRACT, BREACH OF WARRANTY, TORT (INCLUDING NEGLIGENCE), PRODUCT LIABILITY OR ANY OTHER CAUSE OF ACTION OR THEO
RY OF LIABILITY. IN NO EVENT WILL THE TOTAL CUMULATIVE LIABILITY OF ANACONDA AND ITS AFFILIATES UNDER OR ARISING OUT OF THIS AGREEMENT EXCE
ED US0.00.

If you want to terminate this Agreement, you may do so by discontinuing use of Anaconda Individual Edition.  Anaconda may, at any time, ter
minate this Agreement and the license granted hereunder if you fail to comply with any term of this Agreement.   Upon any termination of th
is Agreement, you agree to promptly discontinue use of the Anaconda Individual Edition and destroy all copies in your possession or control
. Upon any termination of this Agreement all provisions survive except for the licenses granted to you.

This Agreement is governed by and construed in accordance with the internal laws of the State of Texas without giving effect to any choice 
or conflict of law provision or rule that would require or permit the application of the laws of any jurisdiction other than those of the S
tate of Texas. Any legal suit, action, or proceeding arising out of or related to this Agreement or the licenses granted hereunder by you m
ust be instituted exclusively in the federal courts of the United States or the courts of the State of Texas in each case located in Travis
 County, Texas, and you irrevocably submit to the jurisdiction of such courts in any such suit, action, or proceeding.


Notice of Third Party Software Licenses
=======================================

Anaconda Individual Edition provides access to a repository which contains software packages or tools licensed on an open source basis from
 third parties and binary packages of these third party tools. These third party software packages or tools are provided on an "as is" basi
s and are subject to their respective license agreements as well as this Agreement and the Terms of Service for the Repository located at h
ttps://know.anaconda.com/TOS.html; provided, however, no restriction contained in the Terms of Service shall be construed so as to limit yo
ur ability to download the packages contained in Anaconda Individual Edition provided you comply with the license for each such package.  T
hese licenses may be accessed from within the Anaconda Individual Edition software or at https://docs.anaconda.com/anaconda/pkg-docs. Infor
mation regarding which license is applicable is available from within many of the third party software packages and tools and at https://re
po.anaconda.com/pkgs/main/ and https://repo.anaconda.com/pkgs/r/. Anaconda reserves the right, in its sole discretion, to change which thir
d party tools are included in the repository accessible through Anaconda Individual Edition.

Intel Math Kernel Library
-------------------------

Anaconda Individual Edition provides access to re-distributable, run-time, shared-library files from the Intel Math Kernel Library ("MKL bi
naries").

Copyright 2018 Intel Corporation.  License available at https://software.intel.com/en-us/license/intel-simplified-software-license (the "MK
L License").

You may use and redistribute the MKL binaries, without modification, provided the following conditions are met:

  * Redistributions must reproduce the above copyright notice and the following terms of use in the MKL binaries and in the documentation a
nd/or other materials provided with the distribution.
  * Neither the name of Intel nor the names of its suppliers may be used to endorse or promote products derived from the MKL binaries witho
ut specific prior written permission.
  * No reverse engineering, decompilation, or disassembly of the MKL binaries is permitted.

You are specifically authorized to use and redistribute the MKL binaries with your installation of Anaconda Individual Edition subject to t
he terms set forth in the MKL License. You are also authorized to redistribute the MKL binaries with Anaconda Individual Edition or in the 
Anaconda package that contains the MKL binaries. If needed, instructions for removing the MKL binaries after installation of Anaconda Indiv
idual Edition are available at https://docs.anaconda.com.

cuDNN Software
--------------

Anaconda Individual Edition also provides access to cuDNN software binaries ("cuDNN binaries") from NVIDIA Corporation. You are specificall
y authorized to use the cuDNN binaries with your installation of Anaconda Individual Edition subject to your compliance with the license ag
reement located at https://docs.nvidia.com/deeplearning/sdk/cudnn-sla/index.html. You are also authorized to redistribute the cuDNN binarie
s with an Anaconda Individual Edition package that contains the cuDNN binaries. You can add or remove the cuDNN binaries utilizing the inst
all and uninstall features in Anaconda Individual Edition.

cuDNN binaries contain source code provided by NVIDIA Corporation.


Export; Cryptography Notice
===========================

You must comply with all domestic and international export laws and regulations that apply to the software, which include restrictions on d
estinations, end users, and end use.  Anaconda Individual Edition includes cryptographic software. The country in which you currently resid
e may have restrictions on the import, possession, use, and/or re-export to another country, of encryption software. BEFORE using any encry
ption software, please check your country's laws, regulations and policies concerning the import, possession, or use, and re-export of encr
yption software, to see if this is permitted. See the Wassenaar Arrangement http://www.wassenaar.org/ for more information.

Anaconda has self-classified this software as Export Commodity Control Number (ECCN) 5D992.c, which includes mass market information securi
ty software using or performing cryptographic functions with asymmetric algorithms. No license is required for export of this software to n
on-embargoed countries.

The Intel Math Kernel Library contained in Anaconda Individual Edition is classified by Intel as ECCN 5D992.c with no license required for 
export to non-embargoed countries.

The following packages are included in the repository accessible through Anaconda Individual Edition that relate to cryptography:

openssl
    The OpenSSL Project is a collaborative effort to develop a robust, commercial-grade, full-featured, and Open Source toolkit implementin
g the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols as well as a full-strength general purpose cryptography libra
ry.

pycrypto
    A collection of both secure hash functions (such as SHA256 and RIPEMD160), and various encryption algorithms (AES, DES, RSA, ElGamal, e
tc.).

pyopenssl
    A thin Python wrapper around (a subset of) the OpenSSL library.

kerberos (krb5, non-Windows platforms)
    A network authentication protocol designed to provide strong authentication for client/server applications by using secret-key cryptogr
aphy.

cryptography
    A Python library which exposes cryptographic recipes and primitives.

pycryptodome
    A fork of PyCrypto. It is a self-contained Python package of low-level cryptographic primitives.

pycryptodomex
    A stand-alone version of pycryptodome.

libsodium
    A software library for encryption, decryption, signatures, password hashing and more.

pynacl
    A Python binding to the Networking and Cryptography library, a crypto library with the stated goal of improving usability, security and
 speed.


Last updated September 28, 2020


Do you accept the license terms? [yes|no]
[no] >>> 
Please answer 'yes' or 'no':'
>>> 
Please answer 'yes' or 'no':'
>>> 
Please answer 'yes' or 'no':'
>>> 
Please answer 'yes' or 'no':'
>>> 
Please answer 'yes' or 'no':'
>>> 
Please answer 'yes' or 'no':'
>>> yes

Miniconda3 will now be installed into this location:
/home/bjorner/miniconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/home/bjorner/miniconda3] >>> 
PREFIX=/home/bjorner/miniconda3
Unpacking payload ...
Collecting package metadata (current_repodata.json): done                                                                                  
Solving environment: done

## Package Plan ##

  environment location: /home/bjorner/miniconda3

  added / updated specs:
    - _libgcc_mutex==0.1=main
    - brotlipy==0.7.0=py38h27cfd23_1003
    - ca-certificates==2020.10.14=0
    - certifi==2020.6.20=pyhd3eb1b0_3
    - cffi==1.14.3=py38h261ae71_2
    - chardet==3.0.4=py38h06a4308_1003
    - conda-package-handling==1.7.2=py38h03888b9_0
    - conda==4.9.2=py38h06a4308_0
    - cryptography==3.2.1=py38h3c74f83_1
    - idna==2.10=py_0
    - ld_impl_linux-64==2.33.1=h53a641e_7
    - libedit==3.1.20191231=h14c3975_1
    - libffi==3.3=he6710b0_2
    - libgcc-ng==9.1.0=hdf63c60_0
    - libstdcxx-ng==9.1.0=hdf63c60_0
    - ncurses==6.2=he6710b0_1
    - openssl==1.1.1h=h7b6447c_0
    - pip==20.2.4=py38h06a4308_0
    - pycosat==0.6.3=py38h7b6447c_1
    - pycparser==2.20=py_2
    - pyopenssl==19.1.0=pyhd3eb1b0_1
    - pysocks==1.7.1=py38h06a4308_0
    - python==3.8.5=h7579374_1
    - readline==8.0=h7b6447c_0
    - requests==2.24.0=py_0
    - ruamel_yaml==0.15.87=py38h7b6447c_1
    - setuptools==50.3.1=py38h06a4308_1
    - six==1.15.0=py38h06a4308_0
    - sqlite==3.33.0=h62c20be_0
    - tk==8.6.10=hbc83047_0
    - tqdm==4.51.0=pyhd3eb1b0_0
    - urllib3==1.25.11=py_0
    - wheel==0.35.1=pyhd3eb1b0_0
    - xz==5.2.5=h7b6447c_0
    - yaml==0.2.5=h7b6447c_0
    - zlib==1.2.11=h7b6447c_3


The following NEW packages will be INSTALLED:

  _libgcc_mutex      pkgs/main/linux-64::_libgcc_mutex-0.1-main
  brotlipy           pkgs/main/linux-64::brotlipy-0.7.0-py38h27cfd23_1003
  ca-certificates    pkgs/main/linux-64::ca-certificates-2020.10.14-0
  certifi            pkgs/main/noarch::certifi-2020.6.20-pyhd3eb1b0_3
  cffi               pkgs/main/linux-64::cffi-1.14.3-py38h261ae71_2
  chardet            pkgs/main/linux-64::chardet-3.0.4-py38h06a4308_1003
  conda              pkgs/main/linux-64::conda-4.9.2-py38h06a4308_0
  conda-package-han~ pkgs/main/linux-64::conda-package-handling-1.7.2-py38h03888b9_0
  cryptography       pkgs/main/linux-64::cryptography-3.2.1-py38h3c74f83_1
  idna               pkgs/main/noarch::idna-2.10-py_0
  ld_impl_linux-64   pkgs/main/linux-64::ld_impl_linux-64-2.33.1-h53a641e_7
  libedit            pkgs/main/linux-64::libedit-3.1.20191231-h14c3975_1
  libffi             pkgs/main/linux-64::libffi-3.3-he6710b0_2
  libgcc-ng          pkgs/main/linux-64::libgcc-ng-9.1.0-hdf63c60_0
  libstdcxx-ng       pkgs/main/linux-64::libstdcxx-ng-9.1.0-hdf63c60_0
  ncurses            pkgs/main/linux-64::ncurses-6.2-he6710b0_1
  openssl            pkgs/main/linux-64::openssl-1.1.1h-h7b6447c_0
  pip                pkgs/main/linux-64::pip-20.2.4-py38h06a4308_0
  pycosat            pkgs/main/linux-64::pycosat-0.6.3-py38h7b6447c_1
  pycparser          pkgs/main/noarch::pycparser-2.20-py_2
  pyopenssl          pkgs/main/noarch::pyopenssl-19.1.0-pyhd3eb1b0_1
  pysocks            pkgs/main/linux-64::pysocks-1.7.1-py38h06a4308_0
  python             pkgs/main/linux-64::python-3.8.5-h7579374_1
  readline           pkgs/main/linux-64::readline-8.0-h7b6447c_0
  requests           pkgs/main/noarch::requests-2.24.0-py_0
  ruamel_yaml        pkgs/main/linux-64::ruamel_yaml-0.15.87-py38h7b6447c_1
  setuptools         pkgs/main/linux-64::setuptools-50.3.1-py38h06a4308_1
  six                pkgs/main/linux-64::six-1.15.0-py38h06a4308_0
  sqlite             pkgs/main/linux-64::sqlite-3.33.0-h62c20be_0
  tk                 pkgs/main/linux-64::tk-8.6.10-hbc83047_0
  tqdm               pkgs/main/noarch::tqdm-4.51.0-pyhd3eb1b0_0
  urllib3            pkgs/main/noarch::urllib3-1.25.11-py_0
  wheel              pkgs/main/noarch::wheel-0.35.1-pyhd3eb1b0_0
  xz                 pkgs/main/linux-64::xz-5.2.5-h7b6447c_0
  yaml               pkgs/main/linux-64::yaml-0.2.5-h7b6447c_0
  zlib               pkgs/main/linux-64::zlib-1.2.11-h7b6447c_3


Preparing transaction: done
Executing transaction: done
installation finished.
Do you wish the installer to initialize Miniconda3
by running conda init? [yes|no]
[no] >>> yes
no change     /home/bjorner/miniconda3/condabin/conda
no change     /home/bjorner/miniconda3/bin/conda
no change     /home/bjorner/miniconda3/bin/conda-env
no change     /home/bjorner/miniconda3/bin/activate
no change     /home/bjorner/miniconda3/bin/deactivate
no change     /home/bjorner/miniconda3/etc/profile.d/conda.sh
no change     /home/bjorner/miniconda3/etc/fish/conf.d/conda.fish
no change     /home/bjorner/miniconda3/shell/condabin/Conda.psm1
no change     /home/bjorner/miniconda3/shell/condabin/conda-hook.ps1
no change     /home/bjorner/miniconda3/lib/python3.8/site-packages/xontrib/conda.xsh
no change     /home/bjorner/miniconda3/etc/profile.d/conda.csh
modified      /home/bjorner/.bashrc

==> For changes to take effect, close and re-open your current shell. <==

If you'd prefer that conda's base environment not be activated on startup, 
   set the auto_activate_base parameter to false: 

conda config --set auto_activate_base false

Thank you for installing Miniconda3!
[bjorner@submit-1 ~]$ 
```


```bash 
(base) [bjorner@submit-1 ~]$ conda create -n HyDe
Collecting package metadata (current_repodata.json): done
Solving environment: done


==> WARNING: A newer version of conda exists. <==
  current version: 4.9.2
  latest version: 4.10.3

Please update conda by running

    $ conda update -n base -c defaults conda



## Package Plan ##

  environment location: /home/bjorner/miniconda3/envs/HyDe



Proceed ([y]/n)? y

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate HyDe
#
# To deactivate an active environment, use
#
#     $ conda deactivate

(base) [bjorner@submit-1 ~]$ conda activate HyDe
(HyDe) [bjorner@submit-1 ~]$ pip install cython numpy matplotlib seaborn multiprocess
Collecting cython
  Downloading https://files.pythonhosted.org/packages/ae/85/9a00bfcd16d481676f2c78550c3f5352197c0436ae6fb9af445242be0edc/Cython-0.29.23-cp27-cp27mu-manylinux1_x86_64.whl (1.9MB)
    100% |████████████████████████████████| 1.9MB 557kB/s 
Collecting numpy
  Downloading https://files.pythonhosted.org/packages/66/03/818876390c7ff4484d5a05398a618cfdaf0a2b9abb3a7c7ccd59fe181008/numpy-1.21.0.zip (10.3MB)
    100% |████████████████████████████████| 10.3MB 109kB/s 
    Complete output from command python setup.py egg_info:
    Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/tmp/pip-build-StO4hn/numpy/setup.py", line 34, in <module>
        raise RuntimeError("Python version >= 3.7 required.")
    RuntimeError: Python version >= 3.7 required.
    
    ----------------------------------------
Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-StO4hn/numpy/
You are using pip version 8.1.2, however version 21.1.3 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(HyDe) [bjorner@submit-1 ~]$ pip install --upgrade pip
Collecting pip
  Downloading https://files.pythonhosted.org/packages/4d/0c/3b63fe024414a8a48661cf04f0993d4b2b8ef92daed45636474c018cd5b7/pip-21.1.3.tar.gz (1.6MB)
    100% |████████████████████████████████| 1.6MB 704kB/s 
Installing collected packages: pip
  Found existing installation: pip 8.1.2
    Uninstalling pip-8.1.2:
Exception:
Traceback (most recent call last):
  File "/usr/lib/python2.7/site-packages/pip/basecommand.py", line 215, in main
    status = self.run(options, args)
  File "/usr/lib/python2.7/site-packages/pip/commands/install.py", line 326, in run
    strip_file_prefix=options.strip_file_prefix,
  File "/usr/lib/python2.7/site-packages/pip/req/req_set.py", line 736, in install
    requirement.uninstall(auto_confirm=True)
  File "/usr/lib/python2.7/site-packages/pip/req/req_install.py", line 742, in uninstall
    paths_to_remove.remove(auto_confirm)
  File "/usr/lib/python2.7/site-packages/pip/req/req_uninstall.py", line 115, in remove
    renames(path, new_path)
  File "/usr/lib/python2.7/site-packages/pip/utils/__init__.py", line 267, in renames
    shutil.move(old, new)
  File "/usr/lib64/python2.7/shutil.py", line 302, in move
    os.unlink(src)
OSError: [Errno 13] Permission denied: '/usr/bin/pip'
You are using pip version 8.1.2, however version 21.1.3 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(HyDe) [bjorner@submit-1 ~]$ conda update -n base -c defaults conda
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /home/bjorner/miniconda3

  added / updated specs:
    - conda


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    _openmp_mutex-4.5          |            1_gnu          22 KB
    ca-certificates-2021.5.25  |       h06a4308_1         112 KB
    certifi-2021.5.30          |   py38h06a4308_0         138 KB
    cffi-1.14.5                |   py38h261ae71_0         224 KB
    chardet-4.0.0              |py38h06a4308_1003         194 KB
    conda-4.10.3               |   py38h06a4308_0         2.9 MB
    conda-package-handling-1.7.3|   py38h27cfd23_1         884 KB
    cryptography-3.4.7         |   py38hd23ed53_0         913 KB
    idna-2.10                  |     pyhd3eb1b0_0          52 KB
    ld_impl_linux-64-2.35.1    |       h7274673_9         586 KB
    libgcc-ng-9.3.0            |      h5101ec6_17         4.8 MB
    libgomp-9.3.0              |      h5101ec6_17         311 KB
    libstdcxx-ng-9.3.0         |      hd4cf53a_17         3.1 MB
    openssl-1.1.1k             |       h27cfd23_0         2.5 MB
    pyopenssl-20.0.1           |     pyhd3eb1b0_1          49 KB
    readline-8.1               |       h27cfd23_0         362 KB
    requests-2.25.1            |     pyhd3eb1b0_0          52 KB
    ruamel_yaml-0.15.100       |   py38h27cfd23_0         258 KB
    setuptools-52.0.0          |   py38h06a4308_0         714 KB
    six-1.16.0                 |     pyhd3eb1b0_0          18 KB
    sqlite-3.36.0              |       hc218d9a_0         990 KB
    tqdm-4.61.1                |     pyhd3eb1b0_1          82 KB
    urllib3-1.26.6             |     pyhd3eb1b0_1         112 KB
    ------------------------------------------------------------
                                           Total:        19.2 MB

The following NEW packages will be INSTALLED:

  _openmp_mutex      pkgs/main/linux-64::_openmp_mutex-4.5-1_gnu
  libgomp            pkgs/main/linux-64::libgomp-9.3.0-h5101ec6_17

The following packages will be REMOVED:

  libedit-3.1.20191231-h14c3975_1
  pip-20.2.4-py38h06a4308_0
  wheel-0.35.1-pyhd3eb1b0_0

The following packages will be UPDATED:

  ca-certificates                              2020.10.14-0 --> 2021.5.25-h06a4308_1
  certifi            pkgs/main/noarch::certifi-2020.6.20-p~ --> pkgs/main/linux-64::certifi-2021.5.30-py38h06a4308_0
  cffi                                1.14.3-py38h261ae71_2 --> 1.14.5-py38h261ae71_0
  chardet                           3.0.4-py38h06a4308_1003 --> 4.0.0-py38h06a4308_1003
  conda                                4.9.2-py38h06a4308_0 --> 4.10.3-py38h06a4308_0
  conda-package-han~                   1.7.2-py38h03888b9_0 --> 1.7.3-py38h27cfd23_1
  cryptography                         3.2.1-py38h3c74f83_1 --> 3.4.7-py38hd23ed53_0
  ld_impl_linux-64                        2.33.1-h53a641e_7 --> 2.35.1-h7274673_9
  libgcc-ng                                9.1.0-hdf63c60_0 --> 9.3.0-h5101ec6_17
  libstdcxx-ng                             9.1.0-hdf63c60_0 --> 9.3.0-hd4cf53a_17
  openssl                                 1.1.1h-h7b6447c_0 --> 1.1.1k-h27cfd23_0
  pyopenssl                             19.1.0-pyhd3eb1b0_1 --> 20.0.1-pyhd3eb1b0_1
  readline                                   8.0-h7b6447c_0 --> 8.1-h27cfd23_0
  requests                                      2.24.0-py_0 --> 2.25.1-pyhd3eb1b0_0
  ruamel_yaml                        0.15.87-py38h7b6447c_1 --> 0.15.100-py38h27cfd23_0
  setuptools                          50.3.1-py38h06a4308_1 --> 52.0.0-py38h06a4308_0
  six                pkgs/main/linux-64::six-1.15.0-py38h0~ --> pkgs/main/noarch::six-1.16.0-pyhd3eb1b0_0
  sqlite                                  3.33.0-h62c20be_0 --> 3.36.0-hc218d9a_0
  tqdm                                  4.51.0-pyhd3eb1b0_0 --> 4.61.1-pyhd3eb1b0_1
  urllib3                                      1.25.11-py_0 --> 1.26.6-pyhd3eb1b0_1

The following packages will be DOWNGRADED:

  idna                                            2.10-py_0 --> 2.10-pyhd3eb1b0_0


Proceed ([y]/n)? y


Downloading and Extracting Packages
certifi-2021.5.30    | 138 KB    | ################################################################################################ | 100% 
cffi-1.14.5          | 224 KB    | ################################################################################################ | 100% 
cryptography-3.4.7   | 913 KB    | ################################################################################################ | 100% 
setuptools-52.0.0    | 714 KB    | ################################################################################################ | 100% 
ld_impl_linux-64-2.3 | 586 KB    | ################################################################################################ | 100% 
readline-8.1         | 362 KB    | ################################################################################################ | 100% 
tqdm-4.61.1          | 82 KB     | ################################################################################################ | 100% 
urllib3-1.26.6       | 112 KB    | ################################################################################################ | 100% 
six-1.16.0           | 18 KB     | ################################################################################################ | 100% 
libstdcxx-ng-9.3.0   | 3.1 MB    | ################################################################################################ | 100% 
chardet-4.0.0        | 194 KB    | ################################################################################################ | 100% 
conda-4.10.3         | 2.9 MB    | ################################################################################################ | 100% 
libgomp-9.3.0        | 311 KB    | ################################################################################################ | 100% 
_openmp_mutex-4.5    | 22 KB     | ################################################################################################ | 100% 
openssl-1.1.1k       | 2.5 MB    | ################################################################################################ | 100% 
ruamel_yaml-0.15.100 | 258 KB    | ################################################################################################ | 100% 
ca-certificates-2021 | 112 KB    | ################################################################################################ | 100% 
pyopenssl-20.0.1     | 49 KB     | ################################################################################################ | 100% 
conda-package-handli | 884 KB    | ################################################################################################ | 100% 
sqlite-3.36.0        | 990 KB    | ################################################################################################ | 100% 
idna-2.10            | 52 KB     | ################################################################################################ | 100% 
requests-2.25.1      | 52 KB     | ################################################################################################ | 100% 
libgcc-ng-9.3.0      | 4.8 MB    | ################################################################################################ | 100% 
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
(HyDe) [bjorner@submit-1 ~]$ pip install cython
Collecting cython
  Using cached https://files.pythonhosted.org/packages/ae/85/9a00bfcd16d481676f2c78550c3f5352197c0436ae6fb9af445242be0edc/Cython-0.29.23-cp27-cp27mu-manylinux1_x86_64.whl
Installing collected packages: cython
Exception:
Traceback (most recent call last):
  File "/usr/lib/python2.7/site-packages/pip/basecommand.py", line 215, in main
    status = self.run(options, args)
  File "/usr/lib/python2.7/site-packages/pip/commands/install.py", line 326, in run
    strip_file_prefix=options.strip_file_prefix,
  File "/usr/lib/python2.7/site-packages/pip/req/req_set.py", line 742, in install
    **kwargs
  File "/usr/lib/python2.7/site-packages/pip/req/req_install.py", line 834, in install
    strip_file_prefix=strip_file_prefix
  File "/usr/lib/python2.7/site-packages/pip/req/req_install.py", line 1037, in move_wheel_files
    strip_file_prefix=strip_file_prefix,
  File "/usr/lib/python2.7/site-packages/pip/wheel.py", line 346, in move_wheel_files
    clobber(source, lib_dir, True)
  File "/usr/lib/python2.7/site-packages/pip/wheel.py", line 324, in clobber
    shutil.copyfile(srcfile, destfile)
  File "/usr/lib64/python2.7/shutil.py", line 83, in copyfile
    with open(dst, 'wb') as fdst:
IOError: [Errno 13] Permission denied: '/usr/lib64/python2.7/site-packages/cython.py'
You are using pip version 8.1.2, however version 21.1.3 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(HyDe) [bjorner@submit-1 ~]$ pip install umpy
Collecting umpy
  Downloading https://files.pythonhosted.org/packages/5c/f5/5ca04eb278fbd78247a81495a28e2c424c04d79788fefe791481a8971eb6/umpy-0.1.0.tar.gz
Installing collected packages: umpy
  Running setup.py install for umpy ... error
    Complete output from command /usr/bin/python2 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-NZmzgM/umpy/setup.py';exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" install --record /tmp/pip-mvg26m-record/install-record.txt --single-version-externally-managed --compile:
    running install
    running build
    running build_py
    creating build
    creating build/lib
    creating build/lib/umpy
    copying umpy/__init__.py -> build/lib/umpy
    copying umpy/um.py -> build/lib/umpy
    running egg_info
    writing umpy.egg-info/PKG-INFO
    writing top-level names to umpy.egg-info/top_level.txt
    writing dependency_links to umpy.egg-info/dependency_links.txt
    warning: manifest_maker: standard file '-c' not found
    
    reading manifest file 'umpy.egg-info/SOURCES.txt'
    writing manifest file 'umpy.egg-info/SOURCES.txt'
    running install_lib
    creating /usr/lib/python2.7/site-packages/umpy
    error: could not create '/usr/lib/python2.7/site-packages/umpy': Permission denied
    
    ----------------------------------------
Command "/usr/bin/python2 -u -c "import setuptools, tokenize;__file__='/tmp/pip-build-NZmzgM/umpy/setup.py';exec(compile(getattr(tokenize, 'open', open)(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" install --record /tmp/pip-mvg26m-record/install-record.txt --single-version-externally-managed --compile" failed with error code 1 in /tmp/pip-build-NZmzgM/umpy/
You are using pip version 8.1.2, however version 21.1.3 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(HyDe) [bjorner@submit-1 ~]$ pip install numpy
Collecting numpy
  Using cached https://files.pythonhosted.org/packages/66/03/818876390c7ff4484d5a05398a618cfdaf0a2b9abb3a7c7ccd59fe181008/numpy-1.21.0.zip
    Complete output from command python setup.py egg_info:
    Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/tmp/pip-build-GVsr2a/numpy/setup.py", line 34, in <module>
        raise RuntimeError("Python version >= 3.7 required.")
    RuntimeError: Python version >= 3.7 required.
    
    ----------------------------------------
Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-GVsr2a/numpy/
You are using pip version 8.1.2, however version 21.1.3 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(HyDe) [bjorner@submit-1 ~]$ python --version
Python 2.7.5
(HyDe) [bjorner@submit-1 ~]$ conda install cython
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /home/bjorner/miniconda3/envs/HyDe

  added / updated specs:
    - cython


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    certifi-2021.5.30          |   py39h06a4308_0         139 KB
    cython-0.29.23             |   py39h2531618_0         2.0 MB
    pip-21.1.3                 |   py39h06a4308_0         1.8 MB
    python-3.9.5               |       h12debd9_4        22.6 MB
    setuptools-52.0.0          |   py39h06a4308_0         724 KB
    tzdata-2021a               |       h52ac0ba_0         108 KB
    wheel-0.36.2               |     pyhd3eb1b0_0          33 KB
    ------------------------------------------------------------
                                           Total:        27.4 MB

The following NEW packages will be INSTALLED:

  _libgcc_mutex      pkgs/main/linux-64::_libgcc_mutex-0.1-main
  _openmp_mutex      pkgs/main/linux-64::_openmp_mutex-4.5-1_gnu
  ca-certificates    pkgs/main/linux-64::ca-certificates-2021.5.25-h06a4308_1
  certifi            pkgs/main/linux-64::certifi-2021.5.30-py39h06a4308_0
  cython             pkgs/main/linux-64::cython-0.29.23-py39h2531618_0
  ld_impl_linux-64   pkgs/main/linux-64::ld_impl_linux-64-2.35.1-h7274673_9
  libffi             pkgs/main/linux-64::libffi-3.3-he6710b0_2
  libgcc-ng          pkgs/main/linux-64::libgcc-ng-9.3.0-h5101ec6_17
  libgomp            pkgs/main/linux-64::libgomp-9.3.0-h5101ec6_17
  libstdcxx-ng       pkgs/main/linux-64::libstdcxx-ng-9.3.0-hd4cf53a_17
  ncurses            pkgs/main/linux-64::ncurses-6.2-he6710b0_1
  openssl            pkgs/main/linux-64::openssl-1.1.1k-h27cfd23_0
  pip                pkgs/main/linux-64::pip-21.1.3-py39h06a4308_0
  python             pkgs/main/linux-64::python-3.9.5-h12debd9_4
  readline           pkgs/main/linux-64::readline-8.1-h27cfd23_0
  setuptools         pkgs/main/linux-64::setuptools-52.0.0-py39h06a4308_0
  sqlite             pkgs/main/linux-64::sqlite-3.36.0-hc218d9a_0
  tk                 pkgs/main/linux-64::tk-8.6.10-hbc83047_0
  tzdata             pkgs/main/noarch::tzdata-2021a-h52ac0ba_0
  wheel              pkgs/main/noarch::wheel-0.36.2-pyhd3eb1b0_0
  xz                 pkgs/main/linux-64::xz-5.2.5-h7b6447c_0
  zlib               pkgs/main/linux-64::zlib-1.2.11-h7b6447c_3


Proceed ([y]/n)? y


Downloading and Extracting Packages
tzdata-2021a         | 108 KB    | ################################################################################################ | 100% 
setuptools-52.0.0    | 724 KB    | ################################################################################################ | 100% 
certifi-2021.5.30    | 139 KB    | ################################################################################################ | 100% 
cython-0.29.23       | 2.0 MB    | ################################################################################################ | 100% 
wheel-0.36.2         | 33 KB     | ################################################################################################ | 100% 
python-3.9.5         | 22.6 MB   | ################################################################################################ | 100% 
pip-21.1.3           | 1.8 MB    | ################################################################################################ | 100% 
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
(HyDe) [bjorner@submit-1 ~]$ conda install numpy matplotlib seaborn multiprocess
Collecting package metadata (current_repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
Collecting package metadata (repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.

PackagesNotFoundError: The following packages are not available from current channels:

  - multiprocess

Current channels:

  - https://repo.anaconda.com/pkgs/main/linux-64
  - https://repo.anaconda.com/pkgs/main/noarch
  - https://repo.anaconda.com/pkgs/r/linux-64
  - https://repo.anaconda.com/pkgs/r/noarch

To search for alternate channels that may provide the conda package you're
looking for, navigate to

    https://anaconda.org

and use the search bar at the top of the page.


(HyDe) [bjorner@submit-1 ~]$ pip install multiprocess
Collecting multiprocess
  Downloading multiprocess-0.70.12.2-py39-none-any.whl (128 kB)
     |████████████████████████████████| 128 kB 4.1 MB/s 
Collecting dill>=0.3.4
  Downloading dill-0.3.4-py2.py3-none-any.whl (86 kB)
     |████████████████████████████████| 86 kB 12.3 MB/s 
Installing collected packages: dill, multiprocess
Successfully installed dill-0.3.4 multiprocess-0.70.12.2
(HyDe) [bjorner@submit-1 ~]$ pip install phyde
Collecting phyde
  Downloading phyde-0.4.3.tar.gz (668 kB)
     |████████████████████████████████| 668 kB 3.2 MB/s 
    ERROR: Command errored out with exit status 255:
     command: /home/bjorner/miniconda3/envs/HyDe/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-1da45rva/phyde_e9fd637924544b05950f46253031a10e/setup.py'"'"'; __file__='"'"'/tmp/pip-install-1da45rva/phyde_e9fd637924544b05950f46253031a10e/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/pip-pip-egg-info-gwf1xqcs
         cwd: /tmp/pip-install-1da45rva/phyde_e9fd637924544b05950f46253031a10e/
    Complete output (11 lines):
    ERROR:
      You are missing the following required modules:
         numpy
         matplotlib
         seaborn
    
    
    ERROR:
      Unable to install phyde.
      Please see the documentation at http://hybridization-detection.rtfd.io/.
    
    ----------------------------------------
WARNING: Discarding https://files.pythonhosted.org/packages/bd/9f/f3838df33ae03a331483ec6193e25d34a06b33d11d96313ac0fe6960e272/phyde-0.4.3.tar.gz#sha256=4869acf3f05e68d92a0adaa095d1fc02036fa691596f4c02543249ccd00c469c (from https://pypi.org/simple/phyde/). Command errored out with exit status 255: python setup.py egg_info Check the logs for full command output.
  Downloading phyde-0.4.2.tar.gz (659 kB)
     |████████████████████████████████| 659 kB 49.6 MB/s 
    ERROR: Command errored out with exit status 255:
     command: /home/bjorner/miniconda3/envs/HyDe/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-1da45rva/phyde_861952d05f6043169d683eedec5e17ba/setup.py'"'"'; __file__='"'"'/tmp/pip-install-1da45rva/phyde_861952d05f6043169d683eedec5e17ba/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/pip-pip-egg-info-y32riboq
         cwd: /tmp/pip-install-1da45rva/phyde_861952d05f6043169d683eedec5e17ba/
    Complete output (11 lines):
    ERROR:
      You are missing the following required modules:
         numpy
         matplotlib
         seaborn
    
    
    ERROR:
      Unable to install phyde.
      Please see the documentation at http://hybridization-detection.rtfd.io/.
    
    ----------------------------------------
WARNING: Discarding https://files.pythonhosted.org/packages/fc/20/4d9bc5157ad9f099db673f752d32191005a01429a0eab831d7d09a41e533/phyde-0.4.2.tar.gz#sha256=27c7b005cfbebd329ac880332eb06ad4510521e6ef9a21414c35766d16c32ad1 (from https://pypi.org/simple/phyde/). Command errored out with exit status 255: python setup.py egg_info Check the logs for full command output.
  Downloading phyde-0.4.1.tar.gz (638 kB)
     |████████████████████████████████| 638 kB 50.1 MB/s 
    ERROR: Command errored out with exit status 255:
     command: /home/bjorner/miniconda3/envs/HyDe/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-1da45rva/phyde_d27e41f010cd42a5a545b6a0894084b9/setup.py'"'"'; __file__='"'"'/tmp/pip-install-1da45rva/phyde_d27e41f010cd42a5a545b6a0894084b9/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/pip-pip-egg-info-wc4qb2h8
         cwd: /tmp/pip-install-1da45rva/phyde_d27e41f010cd42a5a545b6a0894084b9/
    Complete output (11 lines):
    ERROR:
      You are missing the following required modules:
         numpy
         matplotlib
         seaborn
    
    
    ERROR:
      Unable to install phyde.
      Please see the documentation at http://hybridization-detection.rtfd.io/.
    
    ----------------------------------------
WARNING: Discarding https://files.pythonhosted.org/packages/c5/3e/0135ef01a012dfe7a31012b4548a4a58fad5207af4818f22cea99ef3f9df/phyde-0.4.1.tar.gz#sha256=ed154721202f3a13022979fd90d08a6a88f41fd170bbf4c8bc526ec032fcf761 (from https://pypi.org/simple/phyde/). Command errored out with exit status 255: python setup.py egg_info Check the logs for full command output.
  Downloading phyde-0.4.0.tar.gz (639 kB)
     |████████████████████████████████| 639 kB 45.3 MB/s 
    ERROR: Command errored out with exit status 255:
     command: /home/bjorner/miniconda3/envs/HyDe/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-1da45rva/phyde_63ef165a269b4b0cad7b42a139666a8f/setup.py'"'"'; __file__='"'"'/tmp/pip-install-1da45rva/phyde_63ef165a269b4b0cad7b42a139666a8f/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/pip-pip-egg-info-5clseego
         cwd: /tmp/pip-install-1da45rva/phyde_63ef165a269b4b0cad7b42a139666a8f/
    Complete output (12 lines):
    ERROR:
      You are missing the following required modules:
         numpy
         matplotlib
         seaborn
    
    
      Attempting to install them now...
    ERROR:
      Unable to install phyde.
      Please see the documentation at http://hybridization-detection.rtfd.io/.
    
    ----------------------------------------
WARNING: Discarding https://files.pythonhosted.org/packages/3c/b3/afb797906934f51b3f9d7dcb91b675eaaf4e32906e804252944658446eea/phyde-0.4.0.tar.gz#sha256=f7ed67c8a77dd40f8009fb87334f35dcc68fdf5524b8121223cbaef3798667b3 (from https://pypi.org/simple/phyde/). Command errored out with exit status 255: python setup.py egg_info Check the logs for full command output.
  Downloading phyde-0.3.3.tar.gz (430 kB)
     |████████████████████████████████| 430 kB 51.3 MB/s 
ERROR: No .egg-info directory found in /tmp/pip-pip-egg-info-icj1gqip
(HyDe) [bjorner@submit-1 ~]$ pip install numpy
Collecting numpy
  Downloading numpy-1.21.0-cp39-cp39-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (15.7 MB)
     |████████████████████████████████| 15.7 MB 3.7 MB/s 
Installing collected packages: numpy
Successfully installed numpy-1.21.0
(HyDe) [bjorner@submit-1 ~]$ pip install matplotlib
Collecting matplotlib
  Downloading matplotlib-3.4.2-cp39-cp39-manylinux1_x86_64.whl (10.3 MB)
     |████████████████████████████████| 10.3 MB 3.2 MB/s 
Collecting cycler>=0.10
  Downloading cycler-0.10.0-py2.py3-none-any.whl (6.5 kB)
Collecting pyparsing>=2.2.1
  Downloading pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
     |████████████████████████████████| 67 kB 19.5 MB/s 
Collecting python-dateutil>=2.7
  Downloading python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
     |████████████████████████████████| 227 kB 65.6 MB/s 
Collecting pillow>=6.2.0
  Downloading Pillow-8.3.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl (3.0 MB)
     |████████████████████████████████| 3.0 MB 43.0 MB/s 
Requirement already satisfied: numpy>=1.16 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from matplotlib) (1.21.0)
Collecting kiwisolver>=1.0.1
  Downloading kiwisolver-1.3.1-cp39-cp39-manylinux1_x86_64.whl (1.2 MB)
     |████████████████████████████████| 1.2 MB 57.6 MB/s 
Collecting six
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Installing collected packages: six, python-dateutil, pyparsing, pillow, kiwisolver, cycler, matplotlib
Successfully installed cycler-0.10.0 kiwisolver-1.3.1 matplotlib-3.4.2 pillow-8.3.0 pyparsing-2.4.7 python-dateutil-2.8.1 six-1.16.0
(HyDe) [bjorner@submit-1 ~]$ pip install seaborn
Collecting seaborn
  Downloading seaborn-0.11.1-py3-none-any.whl (285 kB)
     |████████████████████████████████| 285 kB 3.6 MB/s 
Collecting scipy>=1.0
  Downloading scipy-1.7.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl (28.4 MB)
     |████████████████████████████████| 28.4 MB 18.5 MB/s 
Requirement already satisfied: matplotlib>=2.2 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from seaborn) (3.4.2)
Collecting pandas>=0.23
  Downloading pandas-1.2.5-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl (9.7 MB)
     |████████████████████████████████| 9.7 MB 58.0 MB/s 
Requirement already satisfied: numpy>=1.15 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from seaborn) (1.21.0)
Requirement already satisfied: kiwisolver>=1.0.1 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from matplotlib>=2.2->seaborn) (1.3.1)
Requirement already satisfied: cycler>=0.10 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from matplotlib>=2.2->seaborn) (0.10.0)
Requirement already satisfied: pillow>=6.2.0 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from matplotlib>=2.2->seaborn) (8.3.0)
Requirement already satisfied: pyparsing>=2.2.1 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from matplotlib>=2.2->seaborn) (2.4.7)
Requirement already satisfied: python-dateutil>=2.7 in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from matplotlib>=2.2->seaborn) (2.8.1)
Requirement already satisfied: six in ./miniconda3/envs/HyDe/lib/python3.9/site-packages (from cycler>=0.10->matplotlib>=2.2->seaborn) (1.16.0)
Collecting pytz>=2017.3
  Downloading pytz-2021.1-py2.py3-none-any.whl (510 kB)
     |████████████████████████████████| 510 kB 55.1 MB/s 
Installing collected packages: pytz, scipy, pandas, seaborn
Successfully installed pandas-1.2.5 pytz-2021.1 scipy-1.7.0 seaborn-0.11.1
(HyDe) [bjorner@submit-1 ~]$ pip install phyde
Collecting phyde
  Using cached phyde-0.4.3.tar.gz (668 kB)
Building wheels for collected packages: phyde
  Building wheel for phyde (setup.py) ... done
  Created wheel for phyde: filename=phyde-0.4.3-cp39-cp39-linux_x86_64.whl size=189840 sha256=1d63dc96c2b0577888b1bf9006cd44024711ae887fb81a765fbaeeeece2aa01c
  Stored in directory: /home/bjorner/.cache/pip/wheels/60/95/b5/acadf4d34e3b03f33be75a035c45da15f3376b25471a9fdb1c
Successfully built phyde
Installing collected packages: phyde
Successfully installed phyde-0.4.3
```