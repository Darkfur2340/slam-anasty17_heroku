#bin/bash
echo "Auto Bot Host Script By Pachax001."
sleep 1
echo "Note- This Is Only For Heroku Branch."
sleep 1
appname=filters$RANDOM
if ! command -v heroku
then
    echo "Heroku could not be found"
    exit
fi
echo "Are You Logged In On Heroku CLi? Type Y OR N."
read login
if ! ( [ "$login" == "Y" ] || [ "$login" == "y" ] )
then 
    echo "Login First"
    exit
fi
echo "1. Type 1 If You Want To Host A New Bot."
echo "2. Type 2 If You Want To Update Old Bot."
read update 
if  ! [ "$update" == "2" ]
then 
echo "Hosting A New Bot"
if ! [ -f config.env ]
then 
    echo "Config Not Found" 
    exit
fi
echo -e "Making a New App\n"
echo -e "Want To Enter Your Own App Name? (Random Name:-$appname Will Be Selected By Default.)\n"
echo -e "Enter An Unique App Name Starting With Lowercase Letter.\n"
echo -e "Dont Enter Anything For Random App Name.(Just Press Enter And Leave It Blank.)\n"
read name
name="${name:=$appname}"
appname=$name
clear
echo -e "Choose The Server Region\n"
echo -e "Enter 1 For US\nEnter 2 For EU\n\nJust Press Enter For US Region(Default)"
read region
region="${region:=1}"
if [ $region == 1 ]
then
region=us
elif [ $region == 2 ]
then
region=eu
else
echo -e "Wrong Input Detected"
echo -e "US Server Is Selected"
region=us
fi
echo "Using $appname As Name."
echo "Using $region As Region For The Bot."
git add . -f
git commit -m token
heroku create --region $region $appname
heroku git:remote -a $appname
heroku stack:set container
heroku addons:create heroku-postgresql
echo "Done"
echo "Pushing"

clear
echo "Avoiding suspension."
heroku apps:destroy --confirm $appname
sleep 2
git add . -f
git commit -m token
heroku create --region $region $appname
heroku git:remote -a $appname
heroku stack:set container
heroku addons:create heroku-postgresql
git push heroku heroku:master -f
echo "Done"
echo "Pushing"

heroku ps:scale web=0
heroku ps:scale web=1
echo "Enjoy"
else 
echo "Updating Bot."
heroku ps:scale web=0
git add . -f
git commit -m token
git push heroku heroku:master -f
heroku ps:scale web=0 
heroku ps:scale web=1 


fi
echo "Done"
echo "Type"
echo "heroku logs -t"
echo "To Check Bot Logs Here."