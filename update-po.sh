#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
. $DIR/settings.sh
cd $DIR

REPO_DIR=$DIR/$SOURCE_DIR

# Clean all
mkdir -p $REPO_DIR

# Clone
git clone --depth=1 $SOURCE_REPO $REPO_DIR
cd $REPO_DIR && git checkout $SOURCE_REVISION
git reset --hard HEAD && git clean -f

# Update pot files
cd $DIR
type po4a
if [ "$?" -eq 0 ]; then
    po4a po4a.cfg
else
    docker run --rm -it -v $(pwd):/build -w /build -u $UID:$GID openstandia/keycloak-documentation po4a --no-translations --package-name="keycloak-documentation-i18n" --package-version=" " --copyright-holder="Nomura Research Institute, Ltd." --msgmerge-opt '--no-location --no-wrap --previous' po4a.cfg
fi

