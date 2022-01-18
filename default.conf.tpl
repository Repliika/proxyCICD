
server {
    listen ${LISTEN_PORT};

    locationn /static {
        alias /vol/static;
    
    }

    location / {
        uwsgi_pass $(APP_HOST):$(APP_PORT);
        include /etc/nginx/uwsgi_params;
        
    }

}