server {
	server_name ${hostname};

	listen 8443 ssl;
	ssl_certificate /etc/nginx/tls/tls.crt;
	ssl_certificate_key /etc/nginx/tls/tls.key;

	gzip on;
	gzip_proxied any;
	gzip_types text/plain text/xml text/css application/javascript;
	gzip_vary on;

	location / {
    add_header Content-Type text/plain;
    return 200 'healthy';
	}
}