#! /bin/bash

#Created by: Samuel Wenninger
#Created on: 07/06/2015
#Last modified: 07/08/2015
#About: This bash script renames all of the files in the current working
##directory. To force all files in the current working directory to be renamed
##without prompting for confirmation, use "-f". To recursively rename all of
##the files in all of the subdirectores, use "-r".

#Rename all of the files in the current directory using proper comp. sci. form
function rename() {
    #Number of changed filenames
    NumChanged=0
    #If no flag, prompt the user for confirmation before renaming files
    if [ $FORCE == 0 ]; then
        read -p "Are you sure you want to rename all files in the current 
        directory to the ab-c01.txt format? [yes/no] " -r
    #If there is a flag (-f), rename files
    else
        REPLY="yes"
    fi
    #Check the REPLY variable which holds the response from the "read" command.
    #Use a regex to check if a "y" or "Y" is entered.
    if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        #cd into the current working directory so that all of the files in said
        #directory can be looped over and renamed
        cd "$PWD"
        #Loop over each file in the current directory
        for i in *
        do
            #The following statments has four parts:
            #1. Echo the name of the file for modification purposes to be piped
            #to the tr (translate characters command.
            #2. Use tr to convert the entire filename to lowercase 
            #3. Use tr to replace all spaces in the filename with dashes
            #4. Use tr -d to delete characters and -c to change characters that
            #are anything other than what is specified. Thus, any character
            #that is not alphanumeric, a dot, an underscore, or a dash will be
            #removed.
            TEMP="$(echo "$i" | tr '[:upper:]' '[:lower:]' | \
                tr -dc '[:alnum:]._-" "' | perl -pe 's/\s*-+\s*/-/g' | \
                tr '[" "_]' '-' | perl -pe 's/--+/-/g')"
            #Don't bother to rename a file that is already in the correct form. 
            #Also, only count files that are actually renamed using NumChanged.
            if [ "$i" != $TEMP ]; then
                mv "$i" "$TEMP"    
                #Show the user what was changed
                echo; echo ""$i" ===> "$TEMP""
                let ++NumChanged
            fi
        done
        echo
        #Report to the user the number of files changed, using proper grammar
        if [ $NumChanged == 1 ]; then
            echo ""$NumChanged" file was renamed in "$PWD""
        else
            echo ""$NumChanged" files were renamed in "$PWD""
        fi
    #If the user selected that no files should be renamed, reassure them that
    #nothing was changed.
    else
        echo; echo "No changes were made"
    fi
}

#Call the rename function recursively on all subdirectories of the specified
#directory. The "find" command is used to accomplish this.
function recursive() {
   read -p "Are you sure you want to rename all of the files within 
   "$PWD" ?  [yes/no] " -r
   if [[ "$REPLY" =~ ^[Nn][Oo]$ ]]; then                                                
       echo; echo "No changes were made"
       exit                                                                    
   fi                                                                          
   find . -type d -exec sh -c 'cd "{}" ; ~/bash-scripts/rename-cs.bash -f ;' \;
}

#Is the renaming forced? Defaultly, no.
FORCE=0
FLAGS=0
#Take care of all of the flags
while getopts fr option
do
case "${option}"
in
f) FORCE=1; rename;let ++FLAGS;;
r) recursive;let ++FLAGS;;
*) echo; echo "Unsupported argument. Use -[fr]"; let ++FLAGS; echo;;
esac
done
if [ $FLAGS == 0 ]; then
    rename
fi
