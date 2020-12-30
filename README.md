# vhs

V HTTP Server

## What's this?

`vhs` is a simple, minimal HTTP server written in V.

## Example

```v
import vhs

// nowaday, below type declarations are needed for anonymous function type definition
type Request = vhs.Request
type Response = vhs.Response

// server handler's context
struct MyContext {
	message string
}

// server handler
struct MyHandler {
	context MyContext
	f fn (MyContext, Request, mut &Response)
}
fn (self MyHandler) handle(req vhs.Request, mut res vhs.Response) {
	h := self.f
	h(self.context, req, mut res)
}

fn main() {
	// prepare handler's context
	context := MyContext {
		message: 'hello, world!'
	}
	// create server and set server handler's function giving response
	mut server := vhs.create_server(MyHandler{
		context: context,
		f: fn (ctx MyContext, req Request, mut res &Response) {
			println(req)
			message := ctx.message
			res.set_header('content-type', 'text/plain')
			res.set_header('content-length', '$message.len')
			res.write(message)
			res.end()
		}
	})
	server.listen(8080)
}
```

## Caution

`vhs` is still in early development!

There are not usefull features yet.

Welcome to contributions!
