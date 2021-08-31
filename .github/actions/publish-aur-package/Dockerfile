FROM archlinux/archlinux:base

RUN \
	# install dependencies
	pacman --needed --noconfirm -Syu base base-devel pacman-contrib git openssh jq && \
	\
	# add user
	useradd -m builder && \
	echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	\
	# prepare ssh
	mkdir -p /root/.ssh && \
	touch /root/.ssh/known_hosts

COPY ssh_config /root/.ssh/config

RUN \
	# fixing ACL
	chmod 600 /root/.ssh/* -R && \
	\
	# install yay
	su - builder -c "cd /home/builder && git clone https://aur.archlinux.org/pikaur.git" && \
	su - builder -c "cd /home/builder/pikaur && makepkg -s" && \
	pacman -U /home/builder/pikaur/pikaur-*.tar.zst --noconfirm && \
	rm -rf /home/builder/pikaur && \
	rm -rf /home/builder/.cache

COPY entrypoint.sh /entrypoint.sh

USER root
WORKDIR /home/builder

ENTRYPOINT ["/entrypoint.sh"]
