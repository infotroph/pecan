#!/bin/bash

#exit on error
set -e

SOURCE_COMMIT=`git log -n1 \
  --format='%nBuilt from commit %h of PEcAn:%n%d %aI%n"%s"%n'`
echo -e According to Git, this is ${SOURCE_COMMIT}
echo -e According to Travis, this is ${TRAVIS_COMMIT} ${TRAVIS_COMMIT_MESSAGE}


#check for environment variable
if [ -z "${GITHUB_PAT}" ]; then
    echo "GITHUB_PAT is not set. Not uploading documentation."
    exit 0
fi

#Print who made GITHUB_PAT variable
echo "GITHUB_PAT variable made by Tony Gardella"

# don't run on pull requests
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This is a pull request, so not uploading documentation until merged."
    exit 0
fi

# find version if we are develop/latest/release and if should be pushed
if [ "$TRAVIS_BRANCH" = "master" ]; then
  VERSION="master"
elif [ "$TRAVIS_BRANCH" = "develop" ]; then
  VERSION="develop"
elif [ "$( echo $TRAVIS_BRANCH | sed -e 's#^release/.*$#release#')" = "release" ]; then
  VERSION="$( echo $TRAVIS_BRANCH | sed -e 's#^release/\(.*\)$#\1#' )"
else
  echo "Not Master, Develop, or Release Branch. Will not upload documentation."
  exit 0
fi

#set USER 
GH_USER=${TRAVIS_REPO_SLUG%/*}

# configure your name and email if you have not done so
git config --global user.email "pecanproj@gmail.com"
git config --global user.name "TRAVIS-DOC-BUILD"

# Don't deploy if documentation git repo does not exist
GH_STATUS=$(curl -s -w %{http_code} -I https://github.com/${GH_USER}/pecan-documentation -o /dev/null)
if [[ $GH_STATUS != 200 ]]; then
  echo "Can't find a repository at https://github.com/${GH_USER}/pecan-documentation"
  echo "Will not upload documentation."
  exit 0
fi

SOURCE_COMMIT=`git log -n1 \
  --format='%nBuilt from commit %h of PEcAn:%n%d %aI%n"%s"%n'`
git clone https://${GITHUB_PAT}@github.com/${GH_USER}/pecan-documentation.git book_hosted
cd book_hosted

## Check if branch named directory exists 
if [ ! -d $VERSION ]; then
  mkdir $VERSION
fi

# copy new documentation
rsync -a --delete ../_book/ $VERSION/

# push updated documentation back up
git add --all *
# NB embedded newlines are intentional
git commit -m "Update the book `date`

  Compiled by Travis CI, build $TRAVIS_BUILD_NUMBER ($TRAVIS_BUILD_ID) job $TRAVIS_JOB_NUMBER ($TRAVIS_JOB_ID)
  $SOURCE_COMMIT" || true
git push -q origin master
