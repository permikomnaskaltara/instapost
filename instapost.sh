#!/bin/bash
# PostBot created by @thelinuxchoice (Don't change , bitch!)
# Instagram: @thelinuxchoice
# Github: https://github.com/thelinuxchoice/postbot
# requires instapy-cli (https://github.com/b3nab/instapy-cli
username=""
password=""
pages="pages.lst"

while [ true ]; do
for page in $(cat $pages); do

lastpost=$(curl -s "https://www.instagram.com/$page/?__a=1/" | grep  -o '"display_url":"https\:\/\/.*.jpg"\,"edge_liked_by"' | cut -d "," -f1 | cut -d ":" -f2,3 | tr -d '\"')
checkvideo=$(curl -s "https://www.instagram.com/$page/?__a=1/" | grep  -o '"display_url":\|"is_video":true' | sed -n '2,2p' )

if [[ $(cat posts.lst | grep -xc "$lastpost") == 0 ]]; then
echo $page
echo $lastpost
printf "%s\n" $lastpost >> posts.lst

check=$(curl -s "https://www.instagram.com/$page/?__a=1/" | grep  -o '"display_url\|edge_media_to_caption":{"edges":\[\]' | sed -n -e '1,1p')

if [[ "$check" == *"edge_media_to_caption"* ]]; then
caption=" "
else
caption=$(echo -en "$(curl -s 'https://www.instagram.com/'$page'/?__a=1/' | grep  -o '{\"text\":\"*.*' | cut -d '}' -f1 | cut -d ':' -f2,3,4)" )
fi

echo $caption

if [[ "$checkvideo" == *"is_video"* ]]; then
echo "Video."
else
instapy -u "$username" -p "$password" -f "$lastpost" -t "$caption Credits: @$page"
sleep 1800
fi
fi

done
done

