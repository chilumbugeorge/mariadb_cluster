# car_team_race

*NOTE: 
 - Replication user is already created in the docker-compose file <master-x/secrets/account.sql>
 - MySQL my.cnf file is already copied from <master-x/conf.d/my.cnf> file each container </etc/mysql/mariadb.conf.d/>
     - The my.cnf does includes all the variables that i normally tune. Most of them are already tuned, but some would depend on the power of the system e.g., innodb_buffer_pool_size.  
 - Inside the repo, there is a docker-compose.yaml which can be run with the following commands:
     - docker-compose up     # To create containers with database nodes for replication
     - docker-compose down   # To stop and remove the containers
 - For replication, with setup instructions below, use binary file and position, and not with GTID setup.   
 - Since replication assumes a new environment with no initial data, the sectup via docker-compose automatically creates a replication user for both Master-1 and Master-2, and this simplifies in making each master the slave of the other without having to take backups.


## ** Setup Master-Master_slave replication [slave1<-Master-1<->Master-2] **

Step 1. Copy IP and binlog info from db-master-1 (car_team_race_db-master-1_1)
hostname -i

MariaDB [(none)]> show master status\G    # copy file value and also position value and add them to MASTER_LOG_FILE and MASTER_LOG_POS in below SQL statement respectively.


Step 2: Start replication on both car_team_race_db-master-2_1 and car_team_race_db-slave_1 by runing the commands below inside mariadb client:

CHANGE MASTER TO
MASTER_HOST='<car_team_race_db-master-1_1_IP-HERE>',
MASTER_USER='slave',
MASTER_PASSWORD='slavepass',
MASTER_PORT=3306,
MASTER_LOG_FILE='binary-log-file-value',
MASTER_LOG_POS=<binary-log-position>,
MASTER_CONNECT_RETRY=10;

START SLAVE;                 # start replication

SHOW SLAVE STATUS\G          # make sure replication is running ok


Step 4: Copy IP and binlog info from db-master-2 (car_team_race_db-master-2_1)
hostname -i

MariaDB [(none)]> show master status\G    # copy file value and also position value and add them to MASTER_LOG_FILE and MASTER_LOG_POS in below SQL statement respectively.

CHANGE MASTER TO
MASTER_HOST='<car_team_race_db-master-2_1_IP-HERE>',
MASTER_USER='slave',
MASTER_PASSWORD='slavepass',
MASTER_PORT=3306,
MASTER_LOG_FILE='<binary-log-file-value>',
MASTER_LOG_POS=<binary-log-position>,
MASTER_CONNECT_RETRY=10;


Step 4: Test replication 

On car_team_race_db-master-1_1, create a table tb1 as follows:

use test;
create table tb1(id int not null auto_increment, name varchar(20) not null, primary key(id));
insert into tb1 values(null, 'Rikki Bobby');

On car_team_race_db-master-2_1 and car_team_race_db-slave-1, check if the table and record were replicated.

Now, on car_team_race_db-master-2_1, insert into new tb1 the following valaues, and see if they show in car_team_race_db-master-1_1 and car_team_race_db-slave-1

insert into tb1 values(null, 'Cal Naughton Jr.');

If you see the records in all thre nodes, then replication is working as expected.
