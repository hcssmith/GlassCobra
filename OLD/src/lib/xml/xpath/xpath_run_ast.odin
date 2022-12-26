package xpath

import "core:fmt"

EResult :: [dynamic]ElementID
AResult :: [dynamic]AttributeID


Result :: union {
    EResult,
    AResult,
}

execute_expression :: proc(doc:^XMLDocument, exp: Expression) -> Result {
  for x:=0;x<len(exp);x+=1 {
    fmt.printf("{0}", exp[x])
  }
    return {}
}

execute_query :: proc(doc: ^XMLDocument, xpath_query: string) -> Result {
    ast := parse_to_ast(xpath_query)

    if ast.IsBrancher {
        
    } else {
      return execute_expression(doc, ast.Exp)
    }
    return {}
}
