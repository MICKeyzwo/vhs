module vhs

import net
import time


const (
	weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
	months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
				'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
)

enum ResponseStatus {
	nothing_written
	body_writing
	finished
}


// The struct used at sending responses
pub struct Response {
	conn net.Socket
	protocol string
mut:
	status ResponseStatus = ResponseStatus.nothing_written
}

// Send status code and write headers
pub fn (res Response) write_head(status_code int, headers map[string]string) {
	status := get_status(status_code)
	mut res_head := '${res.protocol} $status\r\n'
	for key in headers.keys() {
		res_head += '$key: ${headers[key]}\r\n'
	}
	res.conn.write(res_head)
	// TODO: I'd like to update response status here
	// res.status = ResponseStatus.body_writing
}

fn get_default_response_headers() map[string]string {
	return {
		'content-type': 'application/octet-stream',
		'date': '${get_rfc2822_now()}'
	}
}

fn get_rfc2822_now() string {
	now := time.now()
	week := weeks[now.day_of_week() - 1]
	day_tmp := '0${now.day}'
	day := day_tmp.substr(day_tmp.len - 2, day_tmp.len - 1)
	month := months[now.month - 1]
	year := now.year
	time_ := now.hhmmss()
	return '$week, $day $month $year $time_ GMT'
}

// Write content
pub fn (res Response) write(content string) {
	// if res.status == ResponseStatus.nothing_written {
	// 	headers := get_default_response_headers()
	// 	res.write_head(200, headers)
	// }
	res.conn.write('$content')
}

// End to write response content and close connection
pub fn (res Response) end() {
	// if res.status == ResponseStatus.nothing_written {
	// 	headers := get_default_response_headers()
	// 	res.write_head(200, headers)
	// }
	res.conn.close()
	// res.status = ResponseStatus.finished
}
