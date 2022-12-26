package main

import "core:fmt"

import r "lib/xml/reader"

import u "lib/util"

import "core:os"

main :: proc() {
  reader : r.XMLReader

  r.init_reader(&reader, "index.xml") 


  y:= reader->parse_file()

  //for x:=0;x<len(y.Elements);x+=1 {
  //  fmt.printf("{0}\n", y.Elements[x])
  //}

}

