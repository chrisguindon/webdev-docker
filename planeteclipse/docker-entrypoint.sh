#!/bin/bash
###
# Copyright (c) 2017 Eclipse Foundation and others.
# 
# This program and the accompanying materials are made 
# available under the terms of the Eclipse Public License 2.0 
# which accompanies this distribution, and is available
# at http://eclipse.org/legal/epl-2.0
###

PLANETARGS=""
if [ -n $1 ]; then
  PLANETARGS=$1
fi
cd /home/apps/planet

# generate configuration files
echo "Adding configuration files."
cp -f eclipse/planeteclipse.ini eclipse/config_planeteclipse.ini
cp -f eclipse/planetuniverse.ini eclipse/config_planetuniverse.ini

# add feeds to planet eclipse
echo "Adding Planet Eclipse feeds."
cat eclipse/feeds/community.ini >> eclipse/config_planeteclipse.ini

# add feeds to planet universe
echo "Adding Planet Universe feeds."
cat eclipse/feeds/community.ini >> eclipse/config_planetuniverse.ini
cat eclipse/feeds/ecosystem.ini >> eclipse/config_planetuniverse.ini

echo "Updating Planet Universe."
if [ "$PLANETECLIPSE_UPDATE" = "true" ] ; then
  # update universe first (this will fill the cache)
  echo "Updating Planet Universe cache."
  ./planet.py -x $PLANETARGS eclipse/config_planetuniverse.ini
  echo "Planet Universe cache updated."
else
   # update universe from cache
   echo "Updating Planet Universe from cache."
  ./planet.py -o $PLANETARGS eclipse/config_planetuniverse.ini
fi
echo "Planet Universe updated."

# update planet from cache and always rebuild theme
echo "Updating Planet Eclipse from cache."
./planet.py -o $PLANETARGS eclipse/config_planeteclipse.ini
echo "Planet Eclipse updated."

# Start http client
if [ "$PLANETECLIPSE_HTTP_SERVER" = "true" ] ; then
  cd /home/apps/www
  echo "Starting http client."
  python -m SimpleHTTPServer 80
else
  echo "Http client is turned off."
  echo "Exiting..."
fi