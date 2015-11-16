# bash-scripts
The bash-scripts project contains various bash scripts I have written for my own personal use. The following information describes basic purpose of each script.

1. rename-cs.bash
    * Rename all files in the current directory and/or recursively in all subdirectories to the following format (asdf-asdf.txt) where every word is lowercase, multiple words are separated by "-", and there are no spaces in the filename.
   * Options include:
      * -f: force folder to be renamed without confirmation
      * -r: recursively rename all files within the current directory and all subdirectores
      * -p: add the given prefix in front of each file
