# Intro
This container builds the ZNC IRC bouncer.  It's compiled with the [ClientBuffer](https://wiki.znc.in/Clientbuffer) module.

# Usage
This container will need a volume mounted into `/etc/znc`.  All of ZNC's state and configuration is stored in this directory.

You'll then need to place a `/etc/znc/configs/znc.conf` file.  See the [documentation](https://wiki.znc.in/Configuration) for more help.

The ZNC service really doesn't like running as root, so a user and group, both with ID's `1066` are used to run the service.  Make sure the mounted volume and config files are accessible by this user.

Note that the container exposes port `6666` by default, but this is configurable at image built time:
```
docker build --build-arg znc_port=7777 .
```
Be sure that this exposed port matches the listener `Port` in the `znc.conf`. File.
