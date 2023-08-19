# fakeSSH
A Docker image running an SSH server, without access to host resources. Great for testing, honeypots, or for other purposes.

## Why would I use this?
At Hydride, we use this image on some of our machines for many purposes; this includes testing SSH clients, our own client security, as well as a honeypot for potential attackers (our primary use case).

## Usage
fakeSSH can be used with a regular run command, but it is recommended to use a docker-compose file. An example is provided in the repository.

Switch the `dockerfile` property in the docker-compose file to the version you want to use. The default is `alpine`.

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
