
discard """
  cmd:      "nim c -r --styleCheck:hint --panics:on $options $file"
  matrix:   "--gc:arc"
  targets:  "c"
"""
import options
import strformat
import times
import ../src/cookiejar


# forwards can work
block:
  discard secondsForward(0)
  discard daysForward(10)
  discard timesForward(1, 2, 3, 4, 5, 6, 7, 8)


# InitCookie
block:
  let
    username = "admin"
    password = "root"

  discard initCookie(username, password, now())

# SetCookie
block:
  let
    username = "admin"
    password = "root"

  # name-value
  block:
    let 
      cookie = initCookie(username, password)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)

  # domain
  block:
    let 
      domain = "www.netkit.com"
      cookie = initCookie(username, password, domain = domain)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain == domain
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; Domain={cookie.domain}; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)

  # path
  block:
    let 
      path = "/index"
      cookie = initCookie(username, password, path = path)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path == path
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; Path={cookie.path}; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)

  # maxAge
  block:
    let 
      maxAge = 10
      cookie = initCookie(username, password, maxAge = some(maxAge))
    
    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isSome
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; Max-Age={maxAge}; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)
  
  # expires string
  block:
    let 
      expires = "Mon, 6 Apr 2020 12:55:00 GMT"
      cookie = initCookie(username, password, expires)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires == expires
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; Expires={expires}; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)
    
  # expires DateTime
  block:
    let 
      dt = initDateTime(6, mApr, 2020, 13, 3, 0, 0, utc())
      expires = format(dt, "ddd',' dd MMM yyyy HH:mm:ss 'GMT'")
      cookie = initCookie(username, password, expires)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires == expires
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; Expires={expires}; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)

  # secure
  block:
    let
      secure = true
      cookie = initCookie(username, password, secure = secure)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; Secure; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)

  # http-only
  block:
    let 
      httpOnly = true
      cookie = initCookie(username, password, httpOnly = httpOnly)

    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert cookie.httpOnly
    doAssert cookie.samesite == Lax
    doAssert setCookie(cookie) == fmt"{username}={password}; HttpOnly; SameSite=Lax"
    doAssert $cookie == setCookie(cookie)

  # sameSite
  block:
    let 
      sameSite = Strict 
      cookie = initCookie(username, password, sameSite = sameSite)
    
    doAssert cookie.name == username
    doAssert cookie.value == password
    doAssert cookie.expires.len == 0
    doAssert cookie.maxAge.isNone
    doAssert cookie.domain.len == 0
    doAssert cookie.path.len == 0
    doAssert not cookie.secure
    doAssert not cookie.httpOnly
    doAssert cookie.samesite == sameSite
    doAssert setCookie(cookie) == fmt"{username}={password}; SameSite={sameSite}"
    doAssert $cookie == setCookie(cookie)


# Parse
block:
  # parse cookie from string
  block:
    let 
      text = "admin=root; Domain=www.netkit.com; Secure; HttpOnly"
      cookie = initCookie(text)
