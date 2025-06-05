# Xilinx4Nix

Xilinx packaged for Nix.

Work in progress. Currently Vivado is working pretty good.

The main patches done, are running it in a fhs with:
- /nix/store/-/opt is mounted into /opt, during installation time and runtime. This is due to:
  - A bug in the installer. If any ancestors of a choosen installation directory aren't writable, it fails. We cheat through this by mounting `$out/opt` into `/opt` during installation.
  - Paths are hardcoded during installation. We have to run it at the same location as we installed it in.
- We set `LIBRARY_PATH=/lib:/lib64`. Without simulation won't work and will fail with:
-   `/nix/store/*hash*-binutils-2.44/bin/ld: cannot find crt1.o: No such file or directory`
