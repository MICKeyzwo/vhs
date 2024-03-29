module vhs

import net


enum ResponseStatus {
	nothing_written
	body_writing
	finished
}


// The struct used at sending responses
pub struct Response {
	protocol string
mut:
	conn net.TcpConn
	status ResponseStatus = ResponseStatus.nothing_written
	inner_headers map[string]string = {
		'content-type': 'application/octet-stream',
		'date': get_rfc2822_now()
	}
}

// Send status code and write headers
pub fn (mut res Response) write_head(status_code int, headers map[string]string) ? {
	mut res_headers := map[string]string
	if res.inner_headers.keys().len > 0 {
		for key, value in res.inner_headers {
			res_headers[key] = value
		}
	}
	for key, value in headers {
		res_headers[key.to_lower()] = value
	}

	status := get_status(status_code)
	mut res_head := '${res.protocol} $status\r\n'
	for key, value in res_headers {
		res_head += '$key: $value\r\n'
	}
	res.conn.write_string('$res_head\r\n')?
	res.status = ResponseStatus.body_writing
}

// Set header value before sending respons status code and headers
pub fn (mut res Response) set_header(key string, value string) {
	res.inner_headers[key.to_lower()] = value
}

// Get default response used at sending response data without sending headers
fn get_default_response_headers() map[string]string {
	return {
		'content-type': 'application/octet-stream',
		'date': get_rfc2822_now()
	}
}

// Write content
pub fn (mut res Response) write(content string) ? {
	if res.status == ResponseStatus.nothing_written {
		res.write_head(200, map[string]string{})?
	}
	res.conn.write_string(content)?
}

// End to write response content and close connection
pub fn (mut res Response) end() ? {
	if res.status == ResponseStatus.nothing_written {
		res.write_head(200, map[string]string{})?
	}
	res.conn.close()?
	res.status = ResponseStatus.finished
}
