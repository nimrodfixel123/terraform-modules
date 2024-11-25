from http.server import HTTPServer, BaseHTTPRequestHandler
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        logging.info(f"Received GET request from {self.client_address[0]} for path: {self.path}")
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()
        response = 'Hello Alex'
        self.wfile.write(response.encode('utf-8'))
        logging.info(f"Sent response to {self.client_address[0]}")

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), SimpleHTTPRequestHandler)
    logging.info('Starting server on port 8080...')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    server.server_close()
    logging.info('Stopping server...')