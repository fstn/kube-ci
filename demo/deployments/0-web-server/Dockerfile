FROM nginx:latest
ARG folder

## Add the default configuration for React App
COPY $folder/../ /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## Copy the dist result
COPY $folder/../../sources/build /usr/share/nginx/html
