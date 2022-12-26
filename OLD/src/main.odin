package main

import "core:fmt"

import "lib/xml"
import "lib/xml/xpath"

test :: struct {
  fn: proc(^test),
  self: ^test,
}


init_test :: proc(t:^test) {
  t.self = t
}

main :: proc() {
  doc:=xml.parse_file("./index.xml")
  
  t:test

  t.fn = a


  t.fn(t.self)
  

  xpath.execute_query(&doc, "/a/b/c[@class='test']")
}

a :: proc(^test) {
  fmt.printf("test\n")
}
