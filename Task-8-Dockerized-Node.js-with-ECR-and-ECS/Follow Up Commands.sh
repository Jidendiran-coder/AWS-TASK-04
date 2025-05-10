aws configure
# input the following
# Access key ID
# Secret access key
# ap-south-1
# json

# please clone my repo backend branch and make copy in ur own and use from there otherwise it will cause suspicion
git clone https://github.com/JOYSTON-LEWIS/B10_Joyston_Lewis_Assignment_04_DevOps.git

cd B10_Joyston_Lewis_Assignment_04_DevOps/

git checkout Backend

nano .env

PORT=3001
MONGO_URI=MONGOURL

nano Dockerfile
FROM node:20
WORKDIR /app
COPY .env .
COPY . .
RUN npm install
EXPOSE 3001
CMD ["node","index.js"]

docker build -t tm-backend .

docker images

docker run -d -p 3001:3001 tm-backend

docker ps

# check on instance ip at port 3001


aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 975050024946.dkr.ecr.ap-south-1.amazonaws.com

# in place of jl-travelmemory use your docker registry
docker tag tm-backend:latest 975050024946.dkr.ecr.ap-south-1.amazonaws.com/jl-travelmemory:latest

# in place of jl-travelmemory use your docker registry
docker push 975050024946.dkr.ecr.ap-south-1.amazonaws.com/jl-travelmemory:latest

# Follow Steps in Screenshots to do rest of configurations
