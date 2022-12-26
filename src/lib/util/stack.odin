package util

import "core:fmt"

import "core:runtime"

Stack :: struct {
  using base: Obj,
  // fields
  ptr: int, // 0 is empty, 
  arr: [dynamic]rawptr,
  type: typeid,
  // functions
  push:proc(^Stack, any),
  pop:proc(^Stack) -> rawptr,
  skim:proc(^Stack) -> rawptr,
}

init_stack :: proc(self: ^Stack, type: typeid) {
  init_obj(self, "New Stack object")
  
  self.type = type
  self.ptr = 0

  self.push = push
  self.pop = pop
  self.skim = skim
}

push :: proc(self: ^Stack, item: any) {
  using self
  if item.id != type {
    return
  }
  append(&arr, item.data)
  ptr += 1
}

skim :: proc(self: ^Stack) -> rawptr {
  using self
  if ptr == 0 {return nil}
  return arr[ptr-1]
}

pop :: proc(self: ^Stack) -> rawptr {
  using self
  if ptr == 0 {return nil}
  r := self->skim()
  resize_dynamic_array(&arr, ptr-1)
  return r

}
