# Sphinx Search
#
# @version  2.2.11

FROM centos:centos7

# from @link https://github.com/leodido/dockerfiles/blob/master/sphinxsearch:2.2.10/Dockerfile

MAINTAINER inhere<cloud798@126.com>

# environment variables
ENV SPHINX_VERSION=2.2.11-release RE2_VERSION=2016-09-01
ENV SPHINX_INDEX_DIR=/var/idx/sphinx SPHINX_LOG_DIR=/var/log/sphinx
ENV SPHINX_LIB_DIR=/var/lib/sphinx SPHINX_RUN_DIR=/var/run/sphinx SPHINX_DIZ_DIR=/var/diz/sphinx

# add public key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# install utils
RUN yum install -y -q wget tar \
    # install sphinxsearch build dependencies
    autoconf automake libtool gcc-c++ \
    # install sphinxsearch dependencies for odbc
    unixODBC-devel \
    # install sphinxsearch dependencies for mysql, postgresql, xml support
     mysql-devel postgresql-devel expat-devel

# download libstemmer source and extract it
RUN wget -nv -O - http://snowball.tartarus.org/dist/libstemmer_c.tgz | tar zx

# download re2 source and extract it
RUN wget -nv -O - https://github.com/google/re2/archive/${RE2_VERSION}.tar.gz | tar zx

# download sphinxsearch source and extract it
RUN wget -nv -O - http://sphinxsearch.com/files/sphinx-${SPHINX_VERSION}.tar.gz | tar zx

# copy libstemmer inside sphinxsearch source code
RUN cp -R libstemmer_c/* sphinx-${SPHINX_VERSION}/libstemmer_c/

# fix for libstemmer changes
RUN sed -i -e 's/stem_ISO_8859_1_hungarian/stem_ISO_8859_2_hungarian/g' sphinx-${SPHINX_VERSION}/libstemmer_c/Makefile.in

# copy re2 library inside sphinxsearch source code
RUN cp -R re2-${RE2_VERSION}/* sphinx-${SPHINX_VERSION}/libre2/

# compile and install sphinxsearch
RUN cd sphinx-${SPHINX_VERSION} \
    && ./configure --enable-id64 --with-mysql --with-pgsql --with-libstemmer --with-libexpat --with-iconv --with-unixodbc --with-re2 \
    && make && make install

# remove sources
RUN rm -rf sphinx-${SPHINX_VERSION}/ && rm -rf libstemmer_c/ && rm -rf re2-${RE2_VERSION}/

# prepare directories
RUN mkdir -p ${SPHINX_INDEX_DIR} && \
    mkdir -p ${SPHINX_LOG_DIR} && \
    mkdir -p ${SPHINX_LIB_DIR} && \
    mkdir -p ${SPHINX_RUN_DIR} && \
    mkdir -p ${SPHINX_DIZ_DIR}

# dicts
ADD data/packages/sphinx/dicts ${SPHINX_DIZ_DIR}

# scripts
COPY searchd.sh /bin/
COPY indexall.sh /bin/

RUN chmod a+x /bin/searchd.sh && chmod a+x /bin/indexall.sh

# expose directories
VOLUME ["${SPHINX_INDEX_DIR}", "${SPHINX_LOG_DIR}", "${SPHINX_LIB_DIR}",
        "${SPHINX_RUN_DIR}", "${SPHINX_DIZ_DIR}"]

# expose ports
EXPOSE 9312 9306
