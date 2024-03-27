
for k in `cat clusters.txt`
do
	jq '.[ ${k} ].members' clusters.json 
done

 jq '.[0].members' clusters.json 
 
 
 
 echo clusters.json | jq -r '.[].mem' | while read -r cluster; do echo "do something with $repo"; done


echo clusters.json  | jq '.[] | {message: .[], .[].size: .[].members'


## Note the [], this  prevents the json syntax.

jq -r 'keys_unsorted[]' clusters.json 
jq -r 'keys[]' clusters.json 


jq -r 'to_entries[] | [.key, .value.size]' clusters.json

#https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4
#https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/
#https://www.devtoolsdaily.com/cheatsheets/jq/