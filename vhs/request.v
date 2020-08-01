module vhs


// HTTP request struct
pub struct Request {
pub:
	method string
	path string
	protocol string
	headers map[string]string
	body string
}
