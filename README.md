# Remote Docker

This project uses Docker to create an environment where you can run containers on a remote host, in such a way that your local working directory is visible to the container and optionally use X11 to use a GUI.

This allows you to launch Firefox inside a Docker container, using your local ~/Downloads directory, but without access to the rest of your file-system.

You can use this same system to run the latest version of git - when for example your copy of openssh is out of date and github updates the formats of keys - again, or use apt to install an application as a Docker container, or trial some new source without impacting your local environment.

If you want to run version a specific version of Python, you can do that without needing to install it locally.

This uses sshfs to reverse mount the file-system (from the *docker-machine* to your *workstation*), create a docker-volume, then mount that on the container with the working directory set to the mount and taking care of UID and GID.


# Terms and Assumptions

The term *workstation* refers to your "local" environment, where your files live, where you search the web and do your work.

The term *docker-machine* represents a "remote" environment, accessible via ssh that has Docker installed. I use a minimal Debian install, but it could be anything accessible via ssh.

The *docker-machine* is called docker.local and can be connected to by the local user as docker@docker.local. Similarly, the *workstation* can be resolved by its hostname from the *docker-machine* and you can connect to your username from the *docker-machine* to the *workstation*.

Authentication via ssh must be passwordless, use ``ssh-copy-id`` to set it up.


# How it works

The underlying logic does not depend on a local installation of Docker. It uses ``ssh`` to run Docker commands on the remote host. The point of this is that it could run across the Internet, not just to a VM like I'm using it today.

To share files between the Docker container and the local file-system, these scripts use ``docker-mount`` and ``docker-umount`` commands. These commands mount a local directory to a remote directory so it can be used as a Docker volume inside the container. This is achieved in several steps:

1. Connect to the *docker-machine* over ssh.
2. Create a unique empty directory (using uuidgen).
3. Use sshfs from the *docker-machine* to the *workstation* to mount the local directory to the new unique remote directory.
4. Create a Docker volume of that mounted directory.
5. Start a container with that Docker volume.

The ``docker-umount`` does the reverse, removing the volume, un-mounting the sshfs mount, removing the directory.

Note that currently the console displays "Creating volume:" and "Removing volume:" messages. If you know how to make those go away, please provide a patch. (Yes, I'm aware that I'm echoing those strings, it's the volume id from Docker that really needs hiding that I cannot control.)


# Usage

You should be able to run the ``docker`` command as if Docker is installed on your local machine and have it execute remotely. The ``docker.x11`` command should act as-if you launched an X11 application on your local machine. The ``docker-run`` command will mount the current directory inside the container and set the working directory to that same path.

I use this by putting all these scripts in ~/bin. On my *workstation*, I use ~/docker/itmaze/ to store any containers built with ``apt-docker``. All images built using this are tagged itmaze/{xyz}:latest. I am the "default" maintainer for such images. If you do upload any images, you should update the email address (and the tag).

You can create more than one mount and use more than one container at the same time. This is useful if you want to run the aws-cli or git command and provide access to ~/.ssh or ~/.aws as well as the current directory.


# Scripts

The scripts in use are:

- ``docker``, runs Docker commands across ssh on the *docker-machine*.
- ``docker-run``, implements the ``docker run`` command by connecting the current directory to a Docker volume and then adding the volume mount to the ``docker run`` command. Uses ``docker-mount`` and ``docker-umount``.
- ``docker-mount``, creates a unique directory on the *docker-machine* to use as a mount point for sshfs. Mounts the current *workstation* directory via sshfs, and creates a Docker volume from that mount. Uses ``uuidgen``.
- ``docker-umount``, removes the Docker volume, un-mounts sshfs, removes the directory on the *docker-machine*.
- ``docker.x11``, uses ssh x-forwarding to get the X11 packets between the *docker-machine* and the *workstation*. __Security Warning__, this uses ``--net=host``
- ``apt-docker``, attempts to create a minimal container that installs a single Debian application in a debian:stable-slim container and then creates a symlink between the container and your local ~/bin directory, making it look like you just installed an application locally.
- ``make_dockerfile``, create a minimal Dockerfile and launch command, used by ``apt-docker``.
- ``docker-build``, implements ``docker build``, using a tar file of the current directory, sent over ssh to the build command running on the *docker-machine*.
- ``docker.build.me``, build the current directory as a container, tagged with the directory name. Uses ``docker-build``.
- ``docker-compose``, experimental, attempt at implementing a remote docker-compose command, likely broken.
- ``docker-machine``, execute ``docker-machine`` commands on the *docker-machine*.
- ``docker-search``, run ``docker search --no-trunc`` on the *docker-machine*.


# Requirements

There are requirements for both the *docker-machine* and the *workstation*. These are different.

One thing both have in common is that you need to be able to ssh between both without using a password. ``ssh-copy-id`` is the way to make that happen. If you get an error about missing an identity, create one using ``ssh-keygen``. This is required, since we're using ssh from the *workstation* to the *docker-machine* to execute Docker commands and we're using ssh from the *docker-machine* to the *workstation* to mount a directory using sshfs.

## Workstation requirements:
- ssh
- sshd
- uuidgen (uuid-runtime)
- fromdos (tofrodos)

## Docker-Machine requirements:
- docker
- ssh
- sshfs
- write permission on the home directory of the docker user


# Examples

I'm looking at providing some example Dockerfile and launch files. This section will be updated once those are ready to show. Note that the docker-run command shows much of the logic of creating a volume and using it. You can make your own with the same logic to mount something like ~/.ssh or ~/.aws and then call ``docker-run`` to mount the current directory - remember to add the new volume and path to the command, otherwise you're likely to get duplicate mount-point errors.


# Bugs

- There are times when volumes do not un-mount cleanly. Use ``docker volume prune -f`` to remove all unused volumes.
- The quote handling isn't clean, sometimes double quoting is required. This appears to be an ssh *feature*. Using a git container to commit for example requires some shenanigans: ``git commit -m "'Initial commit.'"``


# Kittens Clause

- Fair warning: This isn't feature complete and probably kills kittens.
- Until a few days ago this was a set of scripts on my workstation. Today it's a github project. If you break it, you get to keep both parts.
- Naming isn't consistent.
- I've been experimenting with ``docker-compose`` using the same mechanism.
- There are times when a command doesn't "come back", likely the Docker console is "helping". You can kill the Docker container from another shell using ``docker ps`` and ``docker kill``.
- I have tested this on a bare machine to ensure that it should work for you out of the box, but it might not. If it doesn't please file an issue and I'll have a look.
- Feel free to get in touch, but if you want to fix something or suggest a feature, please create an issue or supply a patch.
- This was inspired by the pioneering hard work by [Jess Frazelle](https://github.com/jessfraz) who introduced me to the idea of running everything inside Docker. My workstation isn't quite there yet, but it's getting closer every day.
- I blame [Corey Quinn](https://www.lastweekinaws.com/t/) for asking silly questions and my mother for not keeping my big mouth shut - enjoy!
