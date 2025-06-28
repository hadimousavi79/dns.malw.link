FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY domains.txt /etc/nginx/domains.txt
COPY domains_with_subdomains.txt /etc/nginx/domains_with_subdomains.txt

RUN [ -f /etc/nginx/domains.txt ] && \
    awk 'NF {print $0 " 1;"}' /etc/nginx/domains.txt > /etc/nginx/whitelist_domains.conf || \
    touch /etc/nginx/whitelist_domains.conf

RUN [ -f /etc/nginx/domains_with_subdomains.txt ] && \
    awk 'NF { gsub(/\./, "\\\\.", $0); print "~\\\\." $0 "$ 1;"; print "~^" $0 "$ 1;" }' \
    /etc/nginx/domains_with_subdomains.txt > /etc/nginx/whitelist_subdomains.conf || \
    touch /etc/nginx/whitelist_subdomains.conf

RUN nginx -t

CMD ["nginx", "-g", "daemon off;"]