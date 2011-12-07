#!/bin/sh

if [ -d chef-repo ]; then
	echo "chef-repo folder already exists. Exiting!"
	exit 1
fi

git --version >> /dev/null

if [ $? != 0 ]; then
	echo "git command does not exist. Exiting!"
	exit 1
fi

echo "cloning OpsCode repo template"
git clone git://github.com/opscode/chef-repo.git

if [ $? != 0 ]; then
	echo "git clone failed, check internet connection. Exiting!"
	exit 1
fi

cd chef-repo

echo "removing git folders from template"
rm -rf .git

echo "initializing new git repo"
git init
git add .
git commit -m "initial commit"

echo "adding site-cookbooks, for custom cookbooks"
mkdir site-cookbooks
echo "Add custom cookbooks here" > site-cookbooks/README
git add site-cookbooks
git commit -m "adding site-cookbooks folder"

echo "adding .chef/knife.rb, for custom knife settings"
mkdir .chef
cat > .chef/knife.rb <<END_OF_FILE
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks", "#{current_dir}/../site-cookbooks"]
END_OF_FILE
git add .chef
git commit -m "adding .chef folder with knife.rb settings for cookbook paths"


echo "You now have a clean Chef repo of your own. Go on and use 'knife cookbook site install COOKBOOK_NAME' to install community cookbooks in a controlled way. Use git submodules to add 3rd party cookbooks"
echo "remaining work is to add scripts for adding 3rd party cookbooks, and more"

