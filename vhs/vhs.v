module vhs

import net
import net.http

const (
	post = 'POST'
	put = 'PUT'
	patch = 'PATCH'
)


// HTTP server
pub struct HttpServer {
	handler fn (Request, mut Response)
	conn net.Socket
}

// Start to listen at given port
pub fn (server HttpServer) listen (port int) {
	server.conn.close()
	listener := net.listen(port) or { panic('failed to listen: $err') }
	for {
		mut conn := listener.accept() or { panic('failed to connect: $err') }
		req := parse_request(mut conn)
		mut res := Response{
			conn: conn
			protocol: req.protocol
		}
		handler := server.handler
		handler(req, mut res)
	}
}

// Read HTTP request and parse into Request struct
fn parse_request (mut conn net.Socket) Request {
	info := conn.read_line().split(' ')
	method := info[0]
	path := info[1]
	protocol := info[2].trim('\r\n')
	mut header_lines := []string{}
	for {
		line := conn.read_line().trim('\r\n')
		if line.len > 0 {
			header_lines << line
		} else {
			break
		}
	}
	headers := http.parse_headers(header_lines)
	mut request_body := ''
	if method == post || method == put || method == patch {
		mut content_len := 0
		if 'content-length' in headers {
			content_len = headers['content-length'].int()
		} else {
			mut res := protocol + get_status(411) + '\r\n'
			res += 'content-type: text/plain\r\n\r\n'
			res += 'Length Required'
			conn.send_string(res)
			conn.close()
			panic('The header does not have `content-length`')
		}
		for request_body.len <= content_len {
			request_body += conn.read_line()
		}
		request_body = request_body.trim('\r\n')
	}
	return Request{
		method: method
		path: path
		protocol: protocol
		headers: headers
		body: request_body
	}
}

// Create new HTTP server
pub fn create_server(handler fn(Request, mut Response)) HttpServer {
	return HttpServer{
		handler: handler
		conn: net.Socket{}
	}
}
