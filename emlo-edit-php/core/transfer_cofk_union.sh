#! /bin/bash
usage="Usage: '$0 <csv-source-directory> <user@server> <remote-directory> [identity-file-location] [force_index]'"

# Check for parameter $1
if [ -z "$1" ]
then
	echo "First parameter not set to csv source directory"
	echo ${usage}
	exit 1
fi

# Check for parameter $2
if [ -z "$2" ]
then
	echo "Second parameter not set to server access string, e.g. user@server"
	echo ${usage}
	exit 1
fi

# Check for parameter $3
if [ -z "$3" ]
then
	echo "Third parameter not set to remote directory"
	echo ${usage}
	exit 1
fi

csv_source=$1
server_access=$2
folder_location=$3
identity_file=$4
force_index=$5

echo "Copying CSV files at ${csv_source} to server ${server_access}:${folder_location}"

remote_location=${server_access}:${folder_location}

for objects in manifestation comment image institution location person relationship relationship_type resource work pro_activity pro_assertion pro_location pro_primary_person pro_relationship pro_role_in_activity pro_textual_source
do
        if test "${objects#*pro_}" != "$objects"
        then
                csv_local_file=${csv_source}/${objects}.csv
        else
                csv_local_file=${csv_source}/cofk_union_${objects}.csv
        fi

        csv_remote_file=${remote_location}/${objects}.csv
        echo "Exporting to $csv_remote_file"

        if [ -z "$identity_file" ]
        then
                rsync -zqt ${csv_local_file} ${csv_remote_file}
        else
                rsync -zqt -e "ssh -i ${identity_file}" ${csv_local_file} ${csv_remote_file}
        fi
done

if [ -z "$identity_file" ]
then
        ssh_settings=""
else
        ssh_settings="-i ${identity_file}"
fi
# When all csv files are copied, update a flag
ssh ${ssh_settings} ${server_access} 'echo '${force_index}' > '${folder_location}/'need_index'

#---------------------------------------------------------------------------------------


