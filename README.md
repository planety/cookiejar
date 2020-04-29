# cookiejar
HTTP Cookies for Nim.
This module provides the `Cookie` type, which directly maps to Set-Cookie HTTP response headers, and the `CookieJar` type which contains many cookies.

## Overview
`Cookie` type is used to generate Set-Cookie HTTP response headers. Server sends Set-Cookie HTTP response headers to the user agent. So the user agent can send them back to the server later.

`CookieJar` contains many cookies from the user agent.

## Usage
```nim
import cookiejar
```
