module vhs

import time


const (
	weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
	months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
				'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
)


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
