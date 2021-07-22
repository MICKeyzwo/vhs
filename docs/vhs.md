# module vhs

## Contents
- [create_server](#create_server)
- [get_rfc2822_now](#get_rfc2822_now)
- [time_to_rfc2822_string](#time_to_rfc2822_string)
- [VhsHandler](#VhsHandler)
- [HttpServer](#HttpServer)
  - [listen](#listen)
  - [close](#close)
- [Request](#Request)
- [Response](#Response)
  - [write_head](#write_head)
  - [set_header](#set_header)
  - [write](#write)
  - [end](#end)

## create_server
```v
fn create_server(handler VhsHandler) HttpServer
```
 Create new HTTP server 

[[Return to contents]](#Contents)

## get_rfc2822_now
```v
fn get_rfc2822_now() string
```
 Get date time string 

[[Return to contents]](#Contents)

## time_to_rfc2822_string
```v
fn time_to_rfc2822_string(target time.Time) string
```
 Get http respons's date 

[[Return to contents]](#Contents)

## VhsHandler
```v
interface VhsHandler {
	handle(Request, mut Response) ?
}
```
 HTTP server's request handler interface 

[[Return to contents]](#Contents)

## HttpServer
```v
struct HttpServer {
	handler VhsHandler
mut:
	listener net.TcpListener
}
```
 HTTP server 

[[Return to contents]](#Contents)

## listen
```v
fn (mut server HttpServer) listen(port int)
```
 Start to listen at given port 

[[Return to contents]](#Contents)

## close
```v
fn (mut server HttpServer) close()
```
 Close HTTP server listener 

[[Return to contents]](#Contents)

## Request
```v
struct Request {
pub:
	method      string
	path        string
	protocol    string
	raw_headers []string
	headers     map[string]string
	body        string
}
```
 HTTP request struct 

[[Return to contents]](#Contents)

## Response
```v
struct Response {
	protocol string
mut:
	conn          net.TcpConn
	status        ResponseStatus    = ResponseStatus.nothing_written
	inner_headers map[string]string = map{
		'content-type': 'application/octet-stream'
		'date':         get_rfc2822_now()
	}
}
```
 The struct used at sending responses 

[[Return to contents]](#Contents)

## write_head
```v
fn (mut res Response) write_head(status_code int, headers map[string]string) ?
```
 Send status code and write headers 

[[Return to contents]](#Contents)

## set_header
```v
fn (mut res Response) set_header(key string, value string)
```
 Set header value before sending respons status code and headers 

[[Return to contents]](#Contents)

## write
```v
fn (mut res Response) write(content string) ?
```
 Write content 

[[Return to contents]](#Contents)

## end
```v
fn (mut res Response) end() ?
```
 End to write response content and close connection 

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 22 Jul 2021 18:41:42
