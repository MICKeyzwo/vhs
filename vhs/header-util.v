module vhs

import time


const (
	weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
	months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
				'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
)


// Parse HTTP headers without normalize
fn parse_raw_headers(lines []string) []string {
	mut res := []string{}
	for line in lines {
		if !line.contains(':') {
			res << line.trim(' \r\n')
		} else {
			parts := line.split(':')
			header_name := parts[0].trim('\r\n')
			mut header_value := ''
			for i in 1..parts.len {
				header_value += parts[i].trim('\r\n') + ':'
			}
			header_value = header_value.trim(' :')
			res << header_name
			res << header_value
		}
	}
	return res
}

// Parse HTTP headers with capitalizing header name
fn parse_capitalized_headers(lines []string) map[string]string {
	mut res := map[string]string
	for line in lines {
		if !line.contains(':') {
			continue
		}
		parts := line.split(':')
		header_name_parts := parts[0].split('-')
		mut header_name := ''
		for header_name_part in header_name_parts {
			if header_name.len > 0 {
				header_name += '-'
			}
			header_name += header_name_part.capitalize()
		}
		res[header_name] = parts[1].trim(' \r\n')
	}
	return res
}

// Get http respons's date
pub fn time_to_rfc2822_string(target time.Time) string {
	week := weeks[target.day_of_week() - 1]
	day_tmp := '0${target.day}'
	day := day_tmp.substr(day_tmp.len - 2, day_tmp.len)
	month := months[target.month - 1]
	year := target.year
	time_ := target.hhmmss()
	return '$week, $day $month $year $time_ GMT'
}

// Get date time string
pub fn get_rfc2822_now() string {
	return time_to_rfc2822_string(time.now())
}
