#! /bin/bash

rsync -aL --progress \
  --exclude Mobile\ Applications \
  --exclude Previous\ iTunes\ Libraries \
  --exclude iTunes\ Music/Podcasts \
  ~/Music/iTunes/ partytimeexcellent.local:Music/iTunes/
