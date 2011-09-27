#! /bin/bash

rsync -aL --progress \
  --exclude Mobile\ Applications \
  --exclude Previous\ iTunes\ Libraries \
  --exclude iTunes\ Music/Podcasts \
  --exclude iTunes\ Music/Movies \
  --exclude iTunes\ Music/TV\ Shows \
  ~/Music/iTunes/ partytimeexcellent.local:Music/iTunes/
