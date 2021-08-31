FROM archlinux/archlinux:base

RUN \
	# install dependencies
	pacman --needed --noconfirm -Syu base base-devel pacman-contrib git openssh jq; \
	\
	# add user
	useradd -m builder; \
	echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
	mkdir -p /home/builder/.ssh; \
	touch /home/builder/.ssh/known_hosts; \
	touch /home/builder/.config; \
	touch /home/builder/.gitconfig;

COPY ssh_config /home/builder/.ssh/config

RUN \
	# fixing ACL
	chown builder:builder /home/builder -R; \
	chmod 600 /home/builder/.ssh/* -R; \
	\
	# install yay
	git clone https://aur.archlinux.org/yay-bin.git; \
	cd yay-bin; \
	su builder -c "makepkg -si";


COPY entrypoint.sh /entrypoint.sh

USER root
WORKDIR /home/builder

ENTRYPOINT ["/entrypoint.sh"]
