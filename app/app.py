from http.server import HTTPServer, BaseHTTPRequestHandler
import logging
import socket

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        client_host = self.client_address[0]
        logging.info(f"Received GET request from {client_host} for path: {self.path}")
        
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        
        response = f'Hello World from {socket.gethostname()}\n'
        self.wfile.write(response.encode('utf-8'))
        logging.info(f"Sent response to {client_host}")

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler):
    server_address = ('0.0.0.0', 8080)
    httpd = server_class(server_address, handler_class)
    
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    logging.info(f'Starting server on {hostname} ({local_ip}:8080)...')
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping server...')

if __name__ == '__main__':
    run()