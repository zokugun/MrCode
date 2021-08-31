FROM archlinux/archlinux:base

RUN \
	# install dependencies
	pacman --needed --noconfirm -Syu base base-devel pacman-contrib git openssh; \
	\
	# add user
	useradd -m builder; \
	echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
	mkdir -p /home/builder/.ssh; \
	touch /home/builder/.ssh/known_hosts;

COPY ssh_config /home/builder/.ssh/config

RUN chown builder:builder /home/builder -R; \
	chmod 600 /home/builder/.ssh/* -R;

COPY entrypoint.sh /entrypoint.sh

USER builder
WORKDIR /home/builder

ENTRYPOINT ["/entrypoint.sh"]
