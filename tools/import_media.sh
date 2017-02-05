#!/bin/bash

IMAGES_PATH=$1
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
PROCESSED_ROOT=$PROJECT_ROOT/source/portfolio

rm -rf $PROCESSED_ROOT
mkdir -p $PROCESSED_ROOT

echo "Working in $IMAGES_PATH:"
cd "$IMAGES_PATH"

find . -iname "*.jpg" -print0 | while IFS= read -r -d '' file_path; do
  new_file_path="$PROCESSED_ROOT/$(dirname "$file_path")/$(basename "${file_path%.*}").jpg"
  echo "$file_path -> $new_file_path"
  mkdir -p "$(dirname "$new_file_path")"
  convert "$file_path" -auto-orient -resize "600x600>" "$new_file_path"
done

find . -iname "*.txt" -print0 | while IFS= read -r -d '' file_path; do
  new_file_path="$PROCESSED_ROOT/$(dirname "$file_path")/$(basename "${file_path}")"
  echo "$file_path -> $new_file_path"
  mkdir -p "$(dirname "$new_file_path")"
  cp "$file_path" "$new_file_path"
done

find . -iname "*.wav" -print0 | while IFS= read -r -d '' file_path; do
  new_file_path="$PROCESSED_ROOT/$(dirname "$file_path")/$(basename "${file_path%.*}").mp3"
  echo "$file_path -> $new_file_path"
  mkdir -p "$(dirname "$new_file_path")"
  ffmpeg -i "$file_path" -f mp3 "$new_file_path" < /dev/null &> /dev/null
done

find . -regex '.*\.\(MOV\|mp4\)' -print0 | while IFS= read -r -d '' file_path; do
  new_file_path="$PROCESSED_ROOT/$(dirname "$file_path")/$(basename "${file_path%.*}").gif"
  echo "$file_path -> $new_file_path"
  mkdir -p "$(dirname "$new_file_path")"
  ffmpeg -i "$file_path" -r 10 -vf scale=600:-1 "$new_file_path" < /dev/null &> /dev/null
done
