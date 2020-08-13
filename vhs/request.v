module vhs

import net


const (
	post = 'POST'
	put = 'PUT'
	patch = 'PATCH'
)


// HTTP request struct
pub struct Request {
pub:
	method string
	path string
	protocol string
	raw_headers []string
	headers map[string]string
	body string
}

// Read HTTP request and parse into Request struct
fn parse_request (conn net.Socket) &Request {
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
	raw_headers := parse_raw_headers(header_lines)
	headers := parse_capitalized_headers(header_lines)
	mut request_body := ''
	if method in [post, put, patch] {
		mut content_len := 0
		if 'Content-Length' in headers {
			content_len = headers['Content-Length'].int()
		} else {
			mut res := '$protocol ${get_status(411)}\r\n'
			res += 'content-type: text/plain\r\n\r\n'
			res += 'Length Required'
			conn.send_string(res)
			conn.close()
		}
		for request_body.len < content_len {
			request_body += conn.read_line()
		}
		request_body = request_body.trim('\r\n')
	}
	return &Request{
		method: method
		path: path
		protocol: protocol
		raw_headers: raw_headers
		headers: headers
		body: request_body
	}
}
