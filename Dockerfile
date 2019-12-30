FROM debian:buster

MAINTAINER aitor3ml <aitor3ml@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :0

ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES:es
ENV LC_ALL es_ES.UTF-8

ENV GNUCASH_VERSION 3.8

RUN printf "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list.d/backports.list \
	printf "deb http://security.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list.d/backports.list \
	printf "deb http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list.d/backports.list \
	&& apt-get update && apt-get install -y locales \
	&& sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=es_ES.UTF-8 \
	&& apt-get -y install git \
	&& git clone --single-branch -b $GNUCASH_VERSION https://github.com/GnuCash/gnucash /tmp/gnucash.git \
	&& cd /tmp/gnucash.git \
	&& apt-get -y install cmake build-essential \
	&& apt-get -y install pkg-config libgtk2.0-dev libxslt1-dev libxml2-dev libwebkit2gtk-4.0-dev \
		swig3.0 guile-2.2-dev libgwenhywfar-core-dev \
		libaqbanking-dev libgwengui-gtk3-dev libofx-dev \
		xsltproc libgmock-dev \
		libdbi-dev libdbd-mysql libdbd-pgsql libdbd-sqlite libdbd-sqlite3 \
		libboost-all-dev=1.62.0.1 \
		libsecret-1-dev \
	&& apt-get install -y libfinance-quote-perl libfinance-quotehist-perl \
		ofx aqbanking-tools \
	&& cmake -D CMAKE_INSTALL_PREFIX=/gnucash /tmp/gnucash.git \
	&& cd /tmp/gnucash.git && make && make install && cd / \
	&& apt-get -y --purge remove git cmake build-essential \
		pkg-config libgtk2.0-dev libxslt1-dev libxml2-dev libwebkit2gtk-4.0-dev \
                swig3.0 guile-2.2-dev libgwenhywfar-core-dev \
                libaqbanking-dev libgwengui-gtk3-dev libofx-dev \
                xsltproc libgmock-dev \
                libdbi-dev libdbd-mysql libdbd-pgsql libdbd-sqlite libdbd-sqlite3 \
		libboost-all-dev=1.62.0.1 \
                libsecret-1-dev \
	&& apt-get -y install guile-2.2 libgtk-3-0 libwebkit2gtk-4.0-37 libboost-locale1.67.0 libboost-filesystem1.67.0 libboost-date-time1.67.0 libboost-regex1.67.0 \
		libdbd-mysql libdbd-pgsql libdbd-sqlite libdbd-sqlite3 dbus-x11 \
	&& apt-get -y autoremove && apt-get clean \
	&& rm -r /tmp/gnucash.git

CMD [ "/gnucash/bin/gnucash", "--logto", "stderr" ]
