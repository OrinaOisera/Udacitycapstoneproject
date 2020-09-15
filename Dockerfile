FROM nginx:latest


## Copy app to container:
COPY index.html  /usr/share/nginx/html 

## Expose the app:
EXPOSE 80