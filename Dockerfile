FROM fscm/debian:buster as build

ARG BUSYBOX_VERSION="1.31.0"
ARG PYTHON_VERSION="3.7.4"

ENV \
  LANG=C.UTF-8 \
  DEBIAN_FRONTEND=noninteractive

COPY files/ /root/

WORKDIR /root

RUN \
# dependencies
  apt-get -qq update && \
  apt-get -qq -y -o=Dpkg::Use-Pty=0 --no-install-recommends install \
    autoconf \
    blt-dev \
    bzip2 \
    curl \
    g++ \
    gcc \
    libbluetooth-dev \
    libbz2-dev \
    libc-dev \
    libc6-dev \
    libczmq-dev \
    libdb-dev \
    libdb5.3-dev \
    libexpat1-dev \
    libffi-dev \
    libgdbm-compat-dev \
    libgdbm-dev \
    libgmp-dev \
    libgpm2 \
    liblzma-dev \
    libmpdec-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtinfo-dev \
    libzmq3-dev \
    libzmq5 \
    llvm \
    make \
    tar \
    tk-dev \
    uuid-dev \
    xz-utils \
    zlib1g-dev && \
# build structure
  install --directory --owner=root --group=root --mode=0755 /build/work && \
  install --directory --owner=root --group=root --mode=1777 /build/tmp && \
  install --directory --owner=root --group=root --mode=0755 /build/usr/bin && \
  ln -s usr/bin /build/bin && \
# busybox
  curl -fsSL --retry 3 --insecure "https://busybox.net/downloads/binaries/${BUSYBOX_VERSION}-i686-uclibc/busybox" -o /build/usr/bin/busybox && \
  chmod +x /build/usr/bin/busybox && \
  for p in [ [[ basename cat cp date dirname du env getopt grep gzip id kill less ln ls mkdir pgrep ps pwd rm sed sh tar wget; do ln /build/usr/bin/busybox /build/usr/bin/${p}; done && \
# python
  install --directory /src/python && \
  curl -fsSL --retry 3 --insecure "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tgz" \
    | tar xz --no-same-owner --strip-components=1 -C /src/python/ && \
  cd /src/python && \
  CFLAGS="-D_FORTIFY_SOURCE=2 -g -fstack-protector-strong -Wformat -Werror=format-security" LDFLAGS="-Wl,-z,relro" CXX="/usr/bin/g++" ./configure \
    --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --quiet \
    --prefix="" \
    --enable-ipv6 \
    --enable-loadable-sqlite-extensions \
    --enable-shared \
    --with-system-expat \
    --with-ensurepip=install && \
  make --silent && \
  make --silent install DESTDIR=/build INSTALL="install -p" && \
  ln -s /build/bin/python${PYTHON_VERSION%.*} /bin/python${PYTHON_VERSION%.*} && \
  LD_LIBRARY_PATH=/build/lib CFLAGS=-I/build/include CPPFLAGS=-I/build/include LDFLAGS=-L/build/lib /build/bin/pip${PYTHON_VERSION%.*} install \
    --upgrade \
    --quiet \
    pip && \
  LD_LIBRARY_PATH=/build/lib CFLAGS=-I/build/include CPPFLAGS=-I/build/include LDFLAGS=-L/build/lib /build/bin/pip${PYTHON_VERSION%.*} install \
    --upgrade \
    --quiet \
    --disable-pip-version-check \
    --no-warn-script-location \
    --no-cache-dir \
    ipyparallel \
    jupyterhub \
    jupyterlab \
    notebook && \
  find /build/lib/python${PYTHON_VERSION%.*} /build/share -depth \( \( -type d -a \( -name test -o -name tests -o -name __pycache__ -o -name man \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.bat' \) \) \) -exec rm -rf '{}' + && \
  for p in $(find /build/bin/ -type f); do s=$(basename ${p}); t=$(dirname ${p})/$(echo ${s} | sed "s/-${PYTHON_VERSION%.*}//;s/${PYTHON_VERSION%.*}m//;s/${PYTHON_VERSION%.*}//"); if [ ! -f "${t}" ]; then ln -s "${s}" "${t}"; fi; done && \
  cd - && \
# system setings
  install --directory --owner=root --group=root --mode=0755 /build/run/systemd && \
  echo 'docker' > /build/run/systemd/container && \
# libs
  curl -fsSL --retry 3 --insecure "https://raw.githubusercontent.com/fscm/tools/master/lddcp/lddcp" -o ./lddcp && \
  chmod +x ./lddcp && \
  ./lddcp $(for f in `find /build/ -type f -executable`; do echo "-p $f "; done) $(for f in `find /lib/x86_64-linux-gnu/ \( -name 'libnss*' -o -name 'libresolv*' \)`; do echo "-l $f "; done) -d /build && \
  rm -rf /build/build && \
# scripts
  install --directory --owner=root --group=root --mode=0755 /build/usr/local && \
  chmod a+x /root/tests/* && \
  cp -R /root/tests /build/usr/local/ && \
  chmod a+x /root/scripts/* && \
  cp /root/scripts/* /build/usr/bin/



FROM scratch

LABEL \
  maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>"

EXPOSE 8888

COPY --from=build \
  /build .

VOLUME ["/work"]

ENV \
  LANG=C.UTF-8 \
  PIP_NO_WARN_SCRIPT_LOCATION=0 \
  PIP_NO_CACHE_DIR=0 \
  PYTHONHOME=/ \
  PYTHONDONTWRITEBYTECODE=1

ENTRYPOINT ["/usr/bin/run"]

CMD ["help"]
