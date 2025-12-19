# Use nginx alpine for a lightweight container
FROM nginx:alpine

# Copy the HTML file to nginx's default html directory
COPY index.html /usr/share/nginx/html/index.html

# Set proper permissions
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
