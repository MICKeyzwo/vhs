module main

import vhs

fn main() {
	server := vhs.create_server(fn (req Request, res Response) {
		println(req)
		res.write_head(200, {'content-type': 'text/plain'})
		res.write('hello, world!')
		res.end()
	})
	server.listen(8080)
}
