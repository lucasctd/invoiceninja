FROM nginx:alpine

COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/public

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
