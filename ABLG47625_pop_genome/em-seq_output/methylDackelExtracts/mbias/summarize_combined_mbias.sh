#!/bin/bash -l

# This script calculates methylation percentages from a combined methylation TSV file.
# Usage: ./summarize_combined_mbias.sh <combined_meth_tsv>

combined_meth_tsv="$1"
bases_to_skip=0
if [ ! -f "$combined_meth_tsv" ]; then
	echo "Usage: $0 <combined_meth_tsv>"
	exit 1
fi
max_possible_read_length=1000
min_pos=$bases_to_skip
read_len=$(cut -f 5 "$combined_meth_tsv" | head -n $max_possible_read_length | sort -n | tail -n 1)
max_pos=$((read_len - bases_to_skip))
script_path=$(dirname "$0")

awk -v min_pos="$min_pos" -v max_pos="$max_pos" \
	-f "${script_path}/per_contig_methylation_from_combined_mbias.awk" <(tail -n +2 "$combined_meth_tsv")

