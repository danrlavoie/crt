#!/bin/bash

# Dir where ID mapping will be saved
repo_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
id_map_dir='/id_mappings'
mkdir -p $repo_dir$id_map_dir

# Date for checkpointing
current_date=$(date +"%m_%d_%Y")
checkpoint_filepath=$repo_dir$id_map_dir"/checkpoint_"

# Files being downloaded
filenames=("movie_ids" "tv_series_ids" "person_ids" "collection_ids" "tv_network_ids" "keyword_ids" "production_company_ids")
file_extension=".json.gz"

# If the checkpoint file does not match today's date, download new files
if [[ ! -e "$checkpoint_filepath$current_date" ]]; then
  # Remove the existing files
  find $repo_dir$id_map_dir -type f -delete

  # Composing the URL for downloading ID mappings
  base_url="http://files.tmdb.org/p/exports/"
  for filename in "${filenames[@]}"; do
    url=$base_url$filename"_"$current_date$file_extension
    curl -o $repo_dir$id_map_dir"/"$filename$file_extension $url
  done

  # Create a new checkpoint file for today
  touch $checkpoint_filepath$current_date
fi

for filename in "${filenames[@]}"; do
  if [[ -e $repo_dir$id_map_dir"/"$filename$file_extension ]]; then
    gzip -d $repo_dir$id_map_dir"/"$filename$file_extension
  fi
done
