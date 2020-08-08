module vhs

import time


// Get http respons's date
fn get_rfc2822_now() string {
	now := time.now()
	week := weeks[now.day_of_week() - 1]
	day_tmp := '0${now.day}'
	day := day_tmp.substr(day_tmp.len - 2, day_tmp.len)
	month := months[now.month - 1]
	year := now.year
	time_ := now.hhmmss()
	return '$week, $day $month $year $time_ GMT'
}
