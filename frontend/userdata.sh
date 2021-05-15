sudo yum update -y
sudo yum upgrade - y
sudo yum install git -y
mkdir projeto
cd projeto
git clone https://github.com/herbsjs/todolist-on-herbs
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install nodejs -y 
sudo yum install postgresql-server postgresql-contrib -y
sudo postgresql-setup initdb
sudo sed -i 's/ ident/ md5/g' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl start postgresql
sudo su - postgres -c  "psql -d template1 -c \"ALTER USER postgres WITH PASSWORD 'postgres';\""
sudo su - postgres -c  "createdb todolist_on_herbs_db"
cd todolist-on-herbs/backend
npm install
npm install knex
npx knex migrate:latest

sudo  bash -c 'cat <<- EOF >/etc/systemd/system/backend.service
[Unit]
Description=backend
After=network.target
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/npm start 
WorkingDirectory=/home/ec2-user/projeto/todolist-on-herbs/backend

 
[Install]
WantedBy=multi-user.target
EOF'


sudo systemctl start backend.service
sudo  bash -c 'cat <<- EOF >/etc/systemd/system/frontend.service
[Unit]
Description=frontend
After=network.target
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/npm start 
WorkingDirectory=/home/ec2-user/projeto/todolist-on-herbs/frontend

 
[Install]
WantedBy=multi-user.target
EOF'


cd ../frontend
npm install 
npm install caniuse-lite
npx browserslist@latest --update-db
sudo systemctl start frontend.service




showmethecode@vortx.com.br