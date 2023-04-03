#!/bin/bash

# for each appearance in this folder of $appearance, substitute $appearance with $replacement
appearance='local tex = vim.g.use_treesitter and require "custom.luasnippets.tex.utils.ts_utils" or require "custom.luasnippets.utils.tex.utils"'
replacement='local tex = vim.g.use_treesitter and require "luasnippets.tex.utils.ts_utils" or require "luasnippets.utils.tex.utils"'

# for each file in this folder
for file in *; do
	# if the file is a directory
	if [ -d "$file" ]; then
		# go into the directory
		cd "$file"
		# run this script again
		../grep.sh
		# go back to the parent directory
		cd ..
	# if the file is a file
	elif [ -f "$file" ]; then
		# if the file contains $appearance
		if grep -q "$appearance" "$file"; then
			# substitute $appearance with $replacement
			sed -i "s|$appearance|$replacement|g" "$file"
		fi
	fi
done
