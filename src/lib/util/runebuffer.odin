package util

import "core:unicode/utf8"

import "core:fmt"

RuneBuffer :: struct {
  using base: Obj,
  _buf: [dynamic]rune,
  ptr:int,
  add:proc(^RuneBuffer, rune),
  clear:proc(^RuneBuffer),
  out:proc(self:^RuneBuffer, begin:int=0, end:int=0) -> string,
  count:proc(^RuneBuffer) -> int,
  rune_at_index:proc(^RuneBuffer, int) -> rune,
  get_string_to_rune:proc(self:^RuneBuffer, ch:..rune, offset:int=0) -> (string, int),
  get_string_to_rune_from_index:proc(self:^RuneBuffer, index:int, ch:..rune, offset:int=0) -> (string, int),
  set_ptr:proc(^RuneBuffer,int),
  next:proc(^RuneBuffer) -> rune,
  peek:proc(^RuneBuffer) -> rune,
  prev:proc(^RuneBuffer) -> rune,

}

init_runebuffer :: proc(buf: ^RuneBuffer) {
  init_obj(buf, "New RuneBuffer")
  buf._buf = [dynamic]rune{}
  buf.ptr = 0
  buf.add = add
  buf.clear = clear
  buf.out = out
  buf.count = count
  buf.rune_at_index = rune_at_index
  buf.get_string_to_rune = get_string_to_rune
  buf.get_string_to_rune_from_index = get_string_to_rune_from_index
  buf.prev = prev
  buf.peek = peek
  buf.next = next
  buf.set_ptr = set_ptr
}

add :: proc(self: ^RuneBuffer, ch: rune) {
  append(&self._buf, ch)
}

clear :: proc(self: ^RuneBuffer) {
  self._buf = [dynamic]rune{}
}

set_ptr :: proc(self: ^RuneBuffer, ptr: int) {
  self.ptr = ptr
}

next :: proc(self: ^RuneBuffer) -> rune {
  if len(self._buf) <= self.ptr {
    return -1
  }
  ch := self._buf[self.ptr]
  self.ptr += 1
  return ch
}

peek :: proc(self: ^RuneBuffer) -> rune {
  return self._buf[self.ptr + 1]
}

prev :: proc(self: ^RuneBuffer) -> rune {
  ch := self._buf[self.ptr -1]
  self.ptr -= 1
  return ch
}



out :: proc(self: ^RuneBuffer, begin : int = 0, end : int = 0) -> string {
  end := end
  if end == 0 {
    end = len(self._buf)  
  } else if end < 0 {
    end = len(self._buf)  + end
  }
  fixed_runes := make([]rune, end-begin)
  copy(fixed_runes, self._buf[begin:end])
  return utf8.runes_to_string(fixed_runes)
}

count :: proc(self: ^RuneBuffer) -> int {
  return len(self._buf)
}

rune_at_index :: proc(self: ^RuneBuffer, index: int) -> rune {
  return self._buf[index]
}

get_string_to_rune :: proc(self: ^RuneBuffer, ch: ..rune, offset:int = 0) -> (string, int) {
  s, i := self->get_string_to_rune_from_index(index = 0, ch = ch, offset=offset)
  return s, i
}

get_string_to_rune_from_index :: proc(self: ^RuneBuffer, index:int, ch:..rune, offset:int=0) -> (string, int) {
  for x:=index;x<len(self._buf);x+=1 {
    for y:=0;y<len(ch);y+=1 {
      if self->rune_at_index(x) == ch[y] {
        return self->out(0, x-offset), x
      }
    }
  }
  return self->out(), len(self._buf)
}

