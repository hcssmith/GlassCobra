package types

import "../../util"

import "core:fmt"

XMLDocument :: struct {
  using base: util.Obj,
  Doctype: Doctype,
  CurrentElementID: ElementID,
  CurrentAttributeID: AttributeID,
  Stylesheet: StyleSheet,
  XMLDeclaration: XMLDeclaration,
  Elements: [dynamic]Element,
  Attributes: [dynamic]Attribute,
  getNewElementId: proc(^XMLDocument) -> ElementID,
  getNewAttributeId: proc(^XMLDocument) -> AttributeID,
  addElement: proc(^XMLDocument, Element),
  addAttribute: proc(^XMLDocument, Attribute),
}

init_xmldocument :: proc(doc: ^XMLDocument) {
  util.init_obj(doc, "XML Document")
  doc.getNewElementId = getNewElementId
  doc.getNewAttributeId = getNewAttributeId
  doc.addElement = addElement
  doc.addAttribute = addAttribute
  doc.CurrentElementID = 0
}

getNewElementId :: proc(self: ^XMLDocument) -> ElementID {
  c := self.CurrentElementID
  self.CurrentElementID += 1
  return c
}

getNewAttributeId :: proc(self: ^XMLDocument) -> AttributeID {
  c := self.CurrentAttributeID
  self.CurrentAttributeID += 1
  return c
}
addElement :: proc(self: ^XMLDocument, e:Element) {
  append(&self.Elements, e)
}
addAttribute :: proc(self: ^XMLDocument, a:Attribute) {
  append(&self.Attributes, a)
}

Attribute :: struct {
  ID: AttributeID,
  Key: string,
  Value: string,
}

Element :: struct {
  using base: util.Obj,
  TagName: string,
  Parent: ElementID,
  ID: ElementID,
  SelfClosing: bool,
  Closer: bool,
  Attributes: [dynamic]AttributeID,
  Children: [dynamic]ElementID,
  Text: string,

  addChildElement:proc(^Element, ElementID),
  addChildAttribute:proc(^Element, AttributeID),
}

init_element :: proc(self: ^Element) {
  util.init_obj(self, "New Element")
  self.addChildElement = addChildElement
  self.addChildAttribute = addChildAttribute
}

addChildElement :: proc(self: ^Element, e: ElementID) {
  append(&self.Children, e)
}

addChildAttribute :: proc(self: ^Element, a: AttributeID) {
  append(&self.Attributes, a)
}

ElementID     :: int
AttributeID   :: int

XMLDeclaration :: struct {
  Version: string,
  Encoding: string,
  Standalone: string,
}

Doctype :: struct {
  Public: string,
  Private: string,
}

StyleSheet :: struct {
  Type: ContentType,
  Href: string,
}

ContentType :: enum {
  xsl,
  css,
  empty,
}

