

from http.server import HTTPServer, BaseHTTPRequestHandler
import logging

HTML_RESPONSE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Hello Alex</title>
</head>
<body>
    <h1>Hello Alex, welcome to terraform modules</h1>
    <script>
        window.onload = function() {
            let speech = new SpeechSynthesisUtterance("Hello Alex");
            speechSynthesis.speak(speech);
        }
    </script>
</body>
</html>
'''

logging.basicConfig(level=logging.INFO)

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()
        self.wfile.write(HTML_RESPONSE.encode('utf-8'))

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), SimpleHTTPRequestHandler)
    logging.info('Starting server on port 8080...')
    server.serve_forever()