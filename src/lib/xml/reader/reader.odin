package reader

import "../../util"
import "../types"

import "core:text/scanner"
import "core:os"
import "core:fmt"
import "core:strings"


XMLReader :: struct {
  using base: util.Obj,
  _scanner: scanner.Scanner,
  _buf: util.RuneBuffer,
  xmlFileName: string,
  contents: string,
  parse_file:proc(^XMLReader) -> types.XMLDocument,
  get_element_tag:proc(^XMLReader) -> (types.Element, [dynamic]types.Attribute),
  get_attr_list:proc(^XMLReader, int) -> ([dynamic]types.Attribute, bool),
}

init_reader :: proc(rd: ^XMLReader, filename:string) {
  util.init_obj(rd, "New XML Reader")

  rd.xmlFileName = filename
  util.init_runebuffer(&rd._buf)


  fd, err := os.open(rd.xmlFileName)
  
  data, success := os.read_entire_file(fd)


  if !success {
    fmt.printf("Could not read contents of: {0}, {1}", rd.xmlFileName, success)
    os.exit(1)
  }
  rd.contents = strings.clone_from_bytes(data)

  scanner.init(&rd._scanner, rd.contents)

  rd.parse_file = parse_file
  rd.get_element_tag = get_element_tag
  rd.get_attr_list = get_attr_list
}

get_element_tag :: proc(self: ^XMLReader) -> (elem: types.Element, attrs: [dynamic]types.Attribute) {
  element_loop: for {
    ch := scanner.next(&self._scanner)
    self._buf->add(ch)
    if ch == '>' {
      break element_loop
    }
  }
  // closing tag
  if self._buf->rune_at_index(0) == '/' {
    elem.Closer = true
    elem.TagName = self._buf->out(1)
    self._buf->clear()
    return
  }
  // get all text to first in >, /, ' ', '\n' '\t'
  name, index := self._buf->get_string_to_rune(' ', '\n', '\t', '/', '>', 1)
  elem.TagName = name

  if self._buf->rune_at_index(index) == '>' {
    self._buf->clear()
    return
  }

  if self._buf->rune_at_index(index) == '/' || self._buf->rune_at_index(index) == '?' {
    elem.SelfClosing = true
  }

  attrs, elem.SelfClosing = self->get_attr_list(index)
  self._buf->clear()
  return
}


//TODO: finish get attr list
get_attr_list :: proc(self: ^XMLReader, index:int) -> (attrs:[dynamic]types.Attribute, selfclosing:bool) {
  selfclosing = false
  self._buf->set_ptr(index)
  buf: util.RuneBuffer
  util.init_runebuffer(&buf)

  outer: for {
    attr: types.Attribute
    key: for {
      ch := self._buf->next()
      if ch == -1 { //EOF
        return
      }
      if ch == '=' {
        attr.Key = strings.trim_space(buf->out())
        break key
      }
      if ch == '/' || ch == '?' || ch == '>' {
        selfclosing = true
        break outer
      }
      buf->add(ch)
    }
    buf->clear()
    c:=0
    val: for {
      ch := self._buf->next()
      if ch == -1 { //EOF
        return
      }
      if (ch == '/' || ch == '?' || ch == '>') && c==0 {
        selfclosing = true
        break outer
      }
      if ch == '"' || ch == '\'' {
        if c > 0 {
          attr.Value = strings.trim_space(buf->out())
          break val
        } else {
          c += 1
          continue val
        }
      }
      if c > 0 {
        buf->add(ch)
      }
    }
    buf->clear()
    append(&attrs, attr)
    attr = {}
  }
  return
}




parse_file :: proc(self: ^XMLReader) -> (types.XMLDocument) {
  doc: types.XMLDocument
  types.init_xmldocument(&doc)
  estack: util.Stack

  util.init_stack(&estack, types.ElementID)
  main_parse_loop: for {
    ch := scanner.next(&self._scanner)
    if ch == scanner.EOF {
      break main_parse_loop
    } else if ch == '<' {
      // if buffer has anything in it, add it to a textonly element and continue
      if self._buf->count() > 0  {
        textOnlyElement: types.Element
        textOnlyElement.TagName = "--TEXTONLY--"
        textOnlyElement.ID = doc->getNewElementId()
        textOnlyElement.Text = strings.trim_space(self._buf->out())
        if textOnlyElement.Text != "" {
          textOnlyElement.Parent = (^int)(estack->skim().data)^
          doc->addElement(textOnlyElement)
        }
        self._buf->clear()
      }
      elem, attrs := self->get_element_tag()
      types.init_element(&elem)
      self._buf->clear()
      for x:=0;x<len(attrs); x+=1 {
        id := doc->getNewAttributeId()
        attr := attrs[x]
        attr.ID = id
        doc->addAttribute(attr)
        elem->addChildAttribute(id)
      }
      elem.ID = doc->getNewElementId()
      if !elem.SelfClosing && !elem.Closer {
        estack->push(elem.ID)
      }
      if !elem.Closer {
        r := estack->skim()
        if r == nil {
          elem.Parent = 0
        } else {
          elem.Parent = (^int)(r.data)^
        }
        doc->addElement(elem)
      }
    } else {
      self._buf->add(ch)
    }
  }
  return doc
}
