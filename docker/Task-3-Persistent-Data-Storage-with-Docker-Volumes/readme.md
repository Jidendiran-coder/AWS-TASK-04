## Task 3: Persistent Data Storage with Docker Volumes

Here are the commands to complete Task 3:

```bash
# Create MySQL container
docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=mydb -e MYSQL_USER=user -e MYSQL_PASSWORD=password -d mysql:5.7

# Create a Docker volume
docker volume create mysql-data

# Stop and remove the first container
docker stop mysql-db
docker rm mysql-db

# Run MySQL with the volume attached
docker run --name mysql-db -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=mydb -e MYSQL_USER=user -e MYSQL_PASSWORD=password -d mysql:5.7

# Connect to MySQL to add data
docker exec -it mysql-db mysql -uroot -prootpassword

# Inside MySQL shell, add data
# CREATE TABLE test (id INT, name VARCHAR(50));
# INSERT INTO test VALUES (1, 'test data');
# SELECT * FROM test;
# exit

# Stop and remove the container again
docker stop mysql-db
docker rm mysql-db

# Run a new container with the same volume
docker run --name new-mysql-db -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=mydb -e MYSQL_USER=user -e MYSQL_PASSWORD=password -d mysql:5.7

# Verify data persistence
docker exec -it new-mysql-db mysql -uroot -prootpassword -e "USE mydb; SELECT * FROM test;"
```
