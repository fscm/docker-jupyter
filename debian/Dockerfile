# global args
ARG __BUILD_DIR__="/build"
ARG __WORK_DIR__="/work"



FROM fscm/python:debian as build

ARG __BUILD_DIR__
ARG __WORK_DIR__
ARG JUPYTERCORE_VERSION="4.7.1"
ARG __USER__="root"

ENV \
  LANG="C.UTF-8" \
  LC_ALL="C.UTF-8"

USER ${__USER__}

#COPY --chown="${__USER__}":${__USER__} "LICENSE" "files/" "${__WORK_DIR__}/"
COPY "LICENSE" "files/" "${__WORK_DIR__}"/

WORKDIR "${__WORK_DIR__}"

SHELL ["/bin/bash", "-c"]

RUN \
# build env
  echo '=== setting build env ===' && \
  time { \
    set +h && \
    export TIMEFORMAT='=== time taken: %lR (s:%lS u:%lU)' ; \
  } && \
# build structure
  echo '=== creating build structure ===' && \
  time { \
    for folder in '/licenses' '/usr/bin'; do install --directory --owner="${__USER__}" --group="${__USER__}" --mode=0755 "${__BUILD_DIR__}${folder}"; done && \
    for folder in '/tmp' "${__WORK_DIR__}"; do install --directory --owner="${__USER__}" --group="${__USER__}" --mode=1777 "${__BUILD_DIR__}${folder}"; done ; \
  } && \
# dependencies
  echo '=== instaling dependencies ===' && \
  time { \
    echo '  nothing to do!' ; \
  } && \
# copy tests
  echo '=== copying test files ===' && \
  time { \
    install --owner="${__USER__}" --group="${__USER__}" --mode=0755 --target-directory="${__BUILD_DIR__}/usr/bin" "${__WORK_DIR__}/tests"/* ; \
  } && \
# copy scripts
  echo '=== copying scripts ===' && \
  time { \
    install --owner="${__USER__}" --group="${__USER__}" --mode=0755 --target-directory="${__BUILD_DIR__}/usr/bin" "${__WORK_DIR__}/scripts"/* ; \
  } && \
# jupyter
  echo '=== installing jupyter ===' && \
  time { \
    _py_prefix_="$(python -c 'import sys; print(sys.prefix)')" && \
    _py_version_="$(python -c "import sys; print(sys.version_info.major, '.', sys.version_info.minor, sep='')")" && \
    pip \
      install \
      --quiet \
      --disable-pip-version-check \
      --no-compile \
      --no-cache-dir \
      --no-warn-script-location \
      --prefix="${_py_prefix_}" \
      --root="${__BUILD_DIR__}" \
      ipyparallel \
      ipywidgets \
      jupyter-core=="${JUPYTERCORE_VERSION}" \
      jupyterhub \
      jupyterlab \
      notebook && \
    find "${__BUILD_DIR__}${_py_prefix_}/lib" -depth -type d -a \( -name 'test' -o -name 'tests' -o -name 'idle_test' -o -name '__pycache__' \) -exec rm -rf '{}' + && \
    find "${__BUILD_DIR__}${_py_prefix_}/lib" -depth -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.bat' -o -name '*.a' \) -delete && \
    rm -rf "${__BUILD_DIR__}${_py_prefix_}/share/info"/* && \
    rm -rf "${__BUILD_DIR__}${_py_prefix_}/share/man"/* ; \
  } && \
# licenses
  echo '=== project licenses ===' && \
  time { \
    install --owner="${__USER__}" --group="${__USER__}" --mode=0644 --target-directory="${__BUILD_DIR__}/licenses" "${__WORK_DIR__}/LICENSE" ; \
  } && \
# check version
  echo '=== installed versions ===' && \
  time { \
    PYTHONPATH="${__BUILD_DIR__}${_py_prefix_}/lib/python${_py_version_}/site-packages" python -m jupyter --version ; \
  } && \
# done
  echo '=== all done! ==='



FROM fscm/python:debian

ARG __BUILD_DIR__
ARG __WORK_DIR__

LABEL \
  maintainer="Frederico Martins <https://hub.docker.com/u/fscm/>" \
  vendor="fscm" \
  cmd="docker container run --detach --publish 8888:8888/tcp fscm/jupyter:debian start" \
  params="--volume ./:${__WORK_DIR__}:rw "

ENV \
  LANG="C.UTF-8" \
  LC_ALL="C.UTF-8" \
  DEBCONF_NONINTERACTIVE_SEEN="true" \
  DEBIAN_FRONTEND="noninteractive" \
  PIP_NO_WARN_SCRIPT_LOCATION=0 \
  PIP_NO_CACHE_DIR=0 \
  PYTHONIOENCODING="UTF-8" \
  WORK_DIR="${__WORK_DIR__}"

EXPOSE \
  8888/tcp

COPY --from=build "${__BUILD_DIR__}" "/"

VOLUME ["${__WORK_DIR__}"]

WORKDIR "${__WORK_DIR__}"

ENTRYPOINT ["/usr/bin/entrypoint"]

CMD ["help"]
