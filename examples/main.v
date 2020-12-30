module main

import vhs

fn main() {
	mut server := vhs.create_server(fn (req Request, mut res Response) {
		println(req)
		message := 'hello, world!'
		res.set_header('content-type', 'text/plain')
		res.set_header('content-length', '$message.len')
		res.write(message)
		res.end()
	})
	server.listen(8080)
}
