module vhs

fn test_init() {
	server := create_server(fn (req Request, res Response) {
		res.write_head(200, {'content-type': 'text/plain'})
		res.write('hello, world!')
		res.end()
	})
	server.listen(8080)
}
