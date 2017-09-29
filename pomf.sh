#!/usr/bin/env bash

# pomf.se uploader v.0.001

# Alternatives:
#upload_url='https://pomf.cat/upload.php'
#return_url='https://a.pomf.cat'

#upload_url='https://mixtape.moe/upload.php'
#return_url='https://my.mixtape.moe'

info_help() {
cat <<-_EOF
single file: 
            ./pomf.sh file.txt
many files: 
            ./pomf.sh file1 file2
            ./pomf.sh *.txt
all files:            
            ./pomf.sh *.*
_EOF
	exit
}

usage()
{
	echo " $0 -help "
        exit 1
}


[ -n "$1" ] || { echo 'No filename given!';   usage; } 
  

#
for FILES in "$@"
do
#

if [ ! -e "$1" ] 
then
case $1 in
h|help|-h|--h|-help|--help)
	info_help
esac
fi

FRS=`echo $FILES | sed 's/[ (),]/_/g'`
mv -v "$FILES" "$FRS" 

[ -f "$FRS" ] || { echo 'File does not exist!'; usage; }


upload_url='https://pomf.space/upload.php'
return_url='https://a.pomf.space'

json_out="$(curl -# --form files[]=@"$FRS" $upload_url)" 

remote_filename="$(echo $json_out | jq -r '.files[0].url')"
success=$(echo $json_out | jq -r '.success')

if [[ $success = true ]] 
then
	file_url="$return_url/$(basename $remote_filename)"
	echo `date +%d.%m.%Y\ %H:%M:%S | tr -d '\012'; echo -n ' ' `
	echo "SHA Checksum $(shasum "$FRS")"   
	echo "$file_url" 
else
	echo 'File upload unsuccessful!'
	exit 1
fi

#
done
#
