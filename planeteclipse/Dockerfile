###
# Copyright (c) 2017 Eclipse Foundation and others.
# 
# This program and the accompanying materials are made 
# available under the terms of the Eclipse Public License 2.0 
# which accompanies this distribution, and is available
# at http://eclipse.org/legal/epl-2.0
###

FROM python:2.7
MAINTAINER Christopher Guindon <chris.guindon@eclipse-foundation.org>

# Setup environment variables
ENV PLANETECLIPSE_HTTP_SERVER "true"
ENV PLANETECLIPSE_UPDATE "true"

# Download Planet Venus and the planeteclipse.org theme
WORKDIR /gitroot
RUN git clone git://github.com/rubys/venus.git
RUN git clone git://git.eclipse.org/gitroot/planeteclipse.org/planeteclipse.org.git

# Move Planet Venus to /home/apps/planet
WORKDIR /home/apps
RUN mv /gitroot/venus /home/apps/planet

# Add planeteclipse.org configs and scripts
WORKDIR /home/apps/planet
RUN ln -s /gitroot/planeteclipse.org/planet/eclipse /home/apps/planet/eclipse
RUN ln -s /gitroot/planeteclipse.org/planet/output /home/apps/planet/output
RUN ln -s /gitroot/planeteclipse.org/planet/updateplanets.sh /home/apps/planet/updateplanets.sh
RUN ln -s /gitroot/planeteclipse.org/planet/fixampersand.sh /home/apps/planet/fixampersand.sh

# Setup webroot for the web server
WORKDIR /home/apps/www
COPY index.html index.html
RUN ln -s /gitroot/planeteclipse.org/planet/output /home/apps/www/planet

# Update default directory
WORKDIR /home/apps/planet

# Expose web server port
EXPOSE 80

# Docker entrypoint
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [""]