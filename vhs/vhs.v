module vhs

import net


// HTTP server
pub struct HttpServer {
	handler fn (Request, mut Response)
mut:
	listener net.TcpListener
}

// Start to listen at given port
pub fn (mut server HttpServer) listen (port int) {
	listener := net.listen_tcp(port) or { panic('failed to listen: $err') }
	server.listener = listener
	for {
		conn := listener.accept() or { panic('failed to connect: $err') }
		go server.handle_request(conn)
	}
}

// Call server handler function. This function is called with `go`
fn (server &HttpServer) handle_request(conn net.TcpConn) {
	req := parse_request(conn) or { panic('failed to parse request') }
	mut res := &Response{
		conn: conn,
		protocol: req.protocol,
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
	return HttpServer{
		handler: handler,
	}
}
