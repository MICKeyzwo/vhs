module vhs

import net


// HTTP server
pub struct HttpServer {
	listener net.Socket
	handler fn (Request, mut Response)
}

// Start to listen at given port
pub fn (server HttpServer) listen (port int) {
	listener := server.listener
	listener.bind(port)
	listener.listen() or { panic('failed to listen: $err') }
	for {
		conn := listener.accept() or { panic('failed to connect: $err') }
		go server.handle_request(conn)
	}
}

// Call server handler function. This function is called with `go`
fn (server HttpServer) handle_request(conn net.Socket) {
	req := parse_request(conn)
	mut res := &Response{
		conn: conn
		protocol: req.protocol
	}
	handler := server.handler
	handler(req, mut res)
}

// Close HTTP server listener
pub fn (server HttpServer) close() {
	server.listener.close() or { panic('failed to close: $err') }
}

// Create new HTTP server
pub fn create_server(handler fn(Request, mut Response)) HttpServer {
	listener := net.new_socket(2, 1, 0) or { panic('failed to create a socket: $err') }
	return HttpServer{
		listener: listener,
		handler: handler,
	}
}
