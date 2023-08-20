**note: these might be outdated, will probably update at some point**
# fakeSSH
A Docker image running an SSH server, without access to host resources. Great for testing, honeypots, or for other purposes.

## Why would I use this?
At Hydride, we use this image on some of our machines for many purposes; this includes testing SSH clients, our own client security, as well as a honeypot for potential attackers (our primary use case).

## Usage
fakeSSH can be used with a regular run command, but it is recommended to use a docker-compose file. An example is provided in the repository.

Switch the `dockerfile` property in the docker-compose file to the version you want to use (in the case of multiple). The default is `alpine`.

## Configuration
fakeSSH can be partially configured with environment variables.

## Tunnel
The tunnel may be configured with environment variables. The following variables are available:

- `SSH_HOST` - The host to run the SSH server on. Defaults to `ssh`.
  
- `SSH_PORT` - The port to run the SSH server on. Defaults to `22`.
  
- `SSH_USER` - The username to use for authentication. Defaults to `sshUser`, the default username within fakeSSH.
  
- `SSH_KEY` - The path to an SSH key for use with authentication. Defaults to `/data/auth/key`. **Passworded keys are not supported.**
  
- `SSH_PASSWORD` - The password to use for authentication. Defaults to `sshPassword`, the default password within fakeSSH.

- `SSH_USE_PASSWORD` - Whether or not to use a password for authentication. Defaults to `false`. If set to `true`, the tunnel will utilise password authentication instead of key authentication using the `SSH_PASSWORD` variable.

Due to the username-password nature of the tunnel, the username and password are both hard-coded into the image. **Forking is recommended in order to change these values.**

## fakeSSH (honeypot)
FakeSSH only provides a single environment variable: enabling SSH password authentication:

- `SSH_USE_PASSWORD` - Whether or not to use a password for authentication. Defaults to `false`. If set to `true`, the honeypot will utilise password authentication *in addition to* key authentication.

However, the following files may be mounted and overwritten in order to change various aspects of the honeypot:

## Configurable files
- `/etc/ssh/sshd_config` - The SSH daemon configuration file. This is the main configuration file for the honeypot, and can be used to change the port, username, password, and more.
  
- `/honeypotShell` - The honeypot login shell, the script that is run when a user connects to the honeypot (in lieu of a proper login shell). By default, this is the honeypot shell python script used by us at Hydride, but it can be replaced with any script you'd like.
  
- `/etc/motd` - The message of the day file, which is displayed to users when they connect to the honeypot.
  
- `/start.sh` - The script that is run when the container starts. By default, this script checks for the existence of SSH keys and generates them if they do not exist. It then starts the SSH daemon.

## Volumes
- `/data` - The data directory used by the honeypot and tunnel. This directory is primarily used in order to share and persist SSH keys between the tunnel and the honeypot. **THIS VOLUME IS REQUIRED FOR THE HONEYPOT TO FUNCTION, AS IT DIRECTLY READS FROM `/data/auth/key.pub`.**

**You should fork the repository in order to gain full control over the honeypot's configuration.**

## Building
After cloning the repository, you'll want to build from the directory containing the version you want to build. For instance, if you'd like to use the Alpine version of fakeSSH, you'll want to build from the `alpine` Dockerfile:

```bash
    docker build -t fakessh:alpine -f alpine/Dockerfile .
```

or you can build with the included docker-compose file:

```bash
    docker-compose build
```

**You must build from the repository's root, as the Dockerfile utilises the `resources` directory.**
