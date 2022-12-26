package util

import "core:fmt"

import "core:runtime"

Stack :: struct {
  using base: Obj,
  // fields
  ptr: int, // 0 is empty, 
  arr: [dynamic]int,
  type: typeid,
  // functions
  push:proc(^Stack, int),
  pop:proc(^Stack) -> Maybe(int),
  skim:proc(^Stack) -> Maybe(int),
}

init_stack :: proc(self: ^Stack, type: typeid) {
  init_obj(self, "New Stack object")
  
  self.type = type
  self.ptr = 0
  switch type {
    case int:
      self.push = int_push
      self.pop = int_pop
      self.skim = int_skim
      break
    case:
  }
}

int_push :: proc(self: ^Stack, item: int) {
  fmt.printf("Pushing: {0}\n", item)
  fmt.printf("Arr:{0} ptr:{1}\n", self.arr, self.ptr)
  using self
  append(&arr, item)
  ptr += 1
}

int_skim :: proc(self: ^Stack) -> Maybe(int) {
  fmt.printf("skim\n")
  fmt.printf("Arr:{0} ptr:{1}\n", self.arr, self.ptr)
  using self
  if ptr == 0 {return nil}
  return arr[ptr-1]
}

int_pop :: proc(self: ^Stack) -> Maybe(int) {
  fmt.printf("pop\n")
  fmt.printf("Arr:{0} ptr:{1}\n", self.arr, self.ptr)
  using self
  if ptr == 0 {return nil}
  r := self->skim()
  resize_dynamic_array(&arr, ptr-1)
  ptr -= 1
  return r

}
