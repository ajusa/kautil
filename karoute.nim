import jester/[patterns]
import tables
include karax/prelude
import dom
type Params = Table[string, string]
type
  Route = object
    n: string
    p: proc (params: Params): VNode

proc urlNorm(url: kstring): string =
  result = $url
  if url.len == 0:
    return "/"
  if url[0] == '#': # remove hash for match
    result = result[1 .. ^1]
var routes*: seq[Route]
template `@`*(field: string): untyped =
  params[field]
template route*(pattern: string, body: untyped) =
  karoute.routes.add(
    Route(n: pattern, p: proc(params{.inject.}: Params): VNode = body)
  )
proc renderRoutes*(router: RouterData): VNode =
  var path = router.hashPart.urlNorm
  for route in routes:
    let pattern = route.n.parsePattern()
    var (matched, params) = pattern.match(path)
    if matched:
      return route.p(params)
  return buildHtml(tdiv): text "error"

proc navigateTo*(uri: cstring) =
    dom.pushState(dom.window.history, 0, cstring"", "#" & uri)

when isMainModule:
  route "/here":
    buildHtml(tdiv):
      text "here"
  route "/":
    buildHtml(tdiv):
      text "Hello World!"
      proc onclick() =
        navigateTo("/here")
  proc createDom(data: RouterData): VNode =
    renderRoutes(data)

  setRenderer createDom
