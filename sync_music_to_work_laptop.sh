#! /bin/bash

rsync -aL --progress \
  --exclude Mobile\ Applications \
  --exclude Previous\ iTunes\ Libraries \
  --exclude iTunes\ Music/Podcasts \
  --exclude Movies \
  ~/Music/iTunes/ trainwreck.local:Music/iTunes/
