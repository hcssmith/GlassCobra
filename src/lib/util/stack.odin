package util

import "core:fmt"

import "core:runtime"

Stack :: struct {
  using base: Obj,
  // fields
  ptr: int, // 0 is empty, 
  arr: [dynamic]any,
  type: typeid,
  // functions
  push:proc(^Stack, any),
  pop:proc(^Stack) -> any,
  skim:proc(^Stack) -> any,
  length:proc(^Stack) -> int,
}

init_stack :: proc(self: ^Stack, type: typeid) {
  init_obj(self, "New Stack object")
  
  self.type = type
  self.ptr = 0

  self.push = push
  self.pop = pop
  self.length = length
  self.skim = skim
}

skim :: proc(self: ^Stack) -> any {
  using self
  if ptr == 0 {
    fmt.printf("SKIM:{0}\n", arr)
    return nil
  } else {
    fmt.printf("SKIM:{0}\n", arr)
    return arr[ptr-1]
  }
}

push :: proc(self: ^Stack, item: any) {
  using self
  fmt.printf("In PUSH: {0}\n", item)
  if item.id != type {
    fmt.printf("PUSH: {0}\n", arr)
    return
  }
  if len(arr) > ptr {
    arr[ptr] = item
  } else {
    append(&arr, item)
  }
  fmt.printf("PUSH: {0}\n", arr)
  ptr+=1
}

pop :: proc(self: ^Stack) -> any {
  if self.ptr == 0 {
    fmt.printf("POP: {0}\n", self.arr)
    return nil
  }
  i:any = self.arr[self.ptr-1]
  self.arr[self.ptr-1] = nil 
  resize_dynamic_array(&self.arr, self.ptr)
  self.ptr = self.ptr-1
  fmt.printf("POP: {0}\n", self.arr)
  return i
}

length :: proc(self: ^Stack) -> int {
  return self.ptr
}

