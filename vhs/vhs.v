module vhs

import net
import net.http

const (
	post = 'POST'
	put = 'PUT'
	patch = 'PATCH'
	
	error_400 = 'HTTP/1.1 400 BadRequest\r\nContent-Type: text/plain\r\nContent-Length header is required.'
)

pub struct Request {

pub:
	method string
	path string
	protocol string
	headers map[string]string
	body string
}

pub struct Response {
	conn net.Socket
}

pub fn (res Response) write_head(status int, headers map[string]string) {
	mut res_head := 'HTTP/1.1 200 OK\r\n'
	for key in headers.keys() {
		res_head += '$key: ${headers[key]}\r\n'
	}
	res.conn.write(res_head)
}

pub fn (res Response) write(content string) {
	res.conn.write('content')
}

pub fn (res Response) end() {
	res.conn.close()
}

pub struct HttpServer {
pub mut:
	handler fn (Request, Response)
	conn net.Socket
// pub:

}

pub fn (server HttpServer) listen (port int) {
	server.conn.close()
	listener := net.listen(port) or { panic('failed to listen: $err') }
	for {
		mut conn := listener.accept() or { panic('failed to connect: $err') }
		req := parse_request(mut conn)
		res := Response{
			conn: conn
		}
		server.handler(req, res)
	}
}

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
			conn.send_string(error_400)
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

pub fn create_server(handler fn(Request, Response)) HttpServer {
	return HttpServer{
		handler: handler
		conn: net.Socket{}
	}
}
