package util

import "core:fmt"

import "core:os"



Obj :: struct {
//  self: ^Obj,
  desc: string,
  to_string: proc(^Obj) -> string,
}

init_obj :: proc(obj: ^Obj, desc: string = "Undefined Object") {
  if obj == nil {
    fmt.printf("Cannot Initialze a nil object... {0}", obj)
    os.exit(1)
  }
  obj.to_string = to_string 
 // obj.self = obj
  obj.desc = desc
}

to_string :: proc(self: ^Obj) -> string {
  return self.desc
}

