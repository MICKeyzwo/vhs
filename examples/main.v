module main

import vhs

// server handler's context
struct MyContext {
	message string
}

// server handler
struct MyHandler {
	context MyContext
	f fn (MyContext, vhs.Request, mut &vhs.Response) ?
}
fn (self MyHandler) handle(req vhs.Request, mut res vhs.Response) ? {
	h := self.f
	h(self.context, req, mut res) ?
}

fn main() {
	// prepare handler's context
	context := MyContext {
		message: 'hello, world!'
	}
	// create server and set server handler's function giving response
	mut server := vhs.create_server(MyHandler{
		context: context,
		f: fn (ctx MyContext, req vhs.Request, mut res &vhs.Response) ? {
			println(req)
			message := ctx.message
			res.set_header('content-type', 'text/plain')
			res.set_header('content-length', '$message.len')
			res.write(message)?
			res.end()?
		}
	})
	server.listen(8080)
}
