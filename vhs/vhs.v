module vhs

import net


const (
	post = 'POST'
	put = 'PUT'
	patch = 'PATCH'
)


// HTTP server
pub struct HttpServer {
	handler fn (Request, mut Response)
	conn &net.Socket
}

// Start to listen at given port
pub fn (server HttpServer) listen (port int) {
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

// Create new HTTP server
pub fn create_server(handler fn(Request, mut Response)) HttpServer {
	return HttpServer{
		handler: handler
		conn: 0
	}
}
