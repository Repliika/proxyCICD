#SECURITY REASONS WE WANT TO RUN NGINX AS NON ROOT
FROM nginxinc/nginx-unprivileged:1-alpine

# NEED TO COPY ALL FILES IN ORDER FOR THE ENTRYPOINT SCRIPT TO CONFIGURE
# NGINX ALSO EXPECTS CONF FILES TO BE IN NGINX
COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./uwsgi_params /etc/nginx/uwsgi_params

# WHAT GETS SUBBED INTO ENTRYPOINT INTO CONF FILE
ENV LISTEN_PORT=8000
ENV APP_HOST=app
ENV APP_PORT=9000

USER root

RUN mkdir -p /vol/static
# CHANGE PERMISSIONS
RUN chmod 755 /vol/static
#IF THIS FILE DOES NOT EXIST, WE CANNOT CHANGE IT, NO DEFAULT PERMISSION FOR NON PRIV USER
#PREEMPTIVELY CREATE IT AND ADD PERMISSIONS, SO ENVSUB CAN SWAP IT NO PROBLEM 
RUN touch /etc/nginx/conf.d/default.conf
#CHANGE OWNER OF THE FILE
RUN chown nginx:nginx /etc/nginx/conf.d/default.conf

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

# DO NOT ROOT ANYMORE
USER nginx

CMD ["/entrypoint.sh"]


