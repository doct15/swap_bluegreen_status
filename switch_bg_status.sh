#!/bin/bash
#
green_content=$(curl -s "https://api.distelli.com/bmcgehee/envs/0green/vars?apiToken=$API_TOKEN")
blue_content=$(curl -s "https://api.distelli.com/bmcgehee/envs/0blue/vars?apiToken=$API_TOKEN")

bg_pos=$(echo "$green_content" | grep -bo '"BG"' |  sed 's/:.*$//')
bg_value_pos=$((bg_pos + 14))
bg_value=${green_content:$bg_value_pos:3}

#echo "$bg_value"

if [ "$bg_value" = "dev" ]; then
  echo "Green is dev, Blue is prd."
  search_green='{"name":"BG","value":"dev"}'
  search_blue='{"name":"BG","value":"prd"}'
else
  echo "Green is prd, Blue is dev."
  search_green='{"name":"BG","value":"prd"}'
  search_blue='{"name":"BG","value":"dev"}'
fi

echo "Switching..."

new_green_content="${green_content/$search_green/$search_blue}"
new_blue_content="${blue_content/$search_blue/$search_green}"

#echo "$green_content"
#echo "$new_green_content"

#echo "$blue_content"
#echo "$new_blue_content"

curl -s -X PUT -H "Content-Type: application/json" "https://api.distelli.com/bmcgehee/envs/0green/vars?apiToken=$API_TOKEN" -d "$new_green_content"
echo ""
curl -s -X PUT -H "Content-Type: application/json" "https://api.distelli.com/bmcgehee/envs/0blue/vars?apiToken=$API_TOKEN" -d "$new_blue_content"
echo ""

