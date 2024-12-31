# Package

version       = "0.3.1"
author        = "ringabout"
description   = "HTTP Cookies for Nim."
license       = "Apache-2.0"
srcDir        = "src"



# Dependencies

requires "nim >= 1.2.6"

task tests, "Run all tests":
  exec "testament all"
