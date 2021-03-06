#/bin/bash
read -p "Please input the platform name you want to pull images, for docker hub, enter 1; for daocloud.io, enter 2, otherwise enter the name of the platform, the default is 1:" choice 
cd ../../Deploy
template_file="docker-compose.yml.template"
yml_file='docker-compose.yml'
if test -e $template_file 
then
  cp $template_file $yml_file
else
  cp $yml_file $template_file
fi
platform=''
choice=${choice:-1} 
if [ $choice == '1' ]
then
  platform='prjharbor/'
elif [ $choice == '2' ]
then
  platform='daocloud.io/harbor/'
else
  platform=$choice
fi
version='0.3.0'
log='deploy_log:'
db='deploy_mysql:'
job_service='deploy_jobservice:'
ui='deploy_ui:'
sed -i -- '/build: .\/log\//c\    image: '$platform$log$version'' $yml_file
sed -i -- '/build: .\/db\//c\    image: '$platform$db$version'' $yml_file
sed -i -- '/ui:/{n;N;N;d}' $yml_file && sed -i -- '/ui:/a\\    image: '$platform$ui$version'' $yml_file
sed -i -- '/jobservice:/{n;N;N;d}' $yml_file && sed -i -- '/jobservice:/a\\    image: '$platform$job_service$version'' $yml_file
echo "succeed! "
