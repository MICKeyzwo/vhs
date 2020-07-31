# vhs
V HTTP Server

## What's this?
`vhs` is a simple, minimal HTTP server written in V.

## Example

```v
import vhs

fn main() {
	server := vhs.create_server(fn (req Request, res Response) {
		res.write_head(200, {'content-type': 'text/plain'})
		res.write('hello, world!')
		res.end()
	})
	server.listen(8080)
}
```

## Caution
`vhs` is still in early development!

There are not usefull features yet.

Welcome to contributions!
