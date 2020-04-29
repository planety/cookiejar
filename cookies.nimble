# Package

version       = "0.1.0"
author        = "flywind"
description   = "HTTP Cookies for Nim."
license       = "Apache-2.0"
srcDir        = "src"



# Dependencies

requires "nim >= 1.2.0"

task tests, "Run all tests":
  exec "testament r test.nim"
