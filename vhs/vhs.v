module vhs

import net


// HTTP server
pub struct HttpServer {
	handler fn (Request, mut Response)
}

// Start to listen at given port
pub fn (server HttpServer) listen (port int) {
	listener := net.listen(port) or { panic('failed to listen: $err') }
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

// Create new HTTP server
pub fn create_server(handler fn(Request, mut Response)) HttpServer {
	return HttpServer{
		handler: handler
	}
}
