import karax/karax
import karax/kajax
import asyncjs
export toJson, fromJson
proc ajaxPost*(url: cstring; headers: openarray[(cstring, cstring)];
          data: cstring;
          cont: proc (httpStatus: int, response: cstring);
          doRedraw: bool = true,
          kxi: KaraxInstance = kxi) =
  ajax("POST", url, headers, data, cont, doRedraw, kxi)

proc ajaxPost*(url: cstring; headers: openarray[(cstring, cstring)];
          data: Blob;
          cont: proc (httpStatus: int, response: cstring);
          doRedraw: bool = true,
          kxi: KaraxInstance = kxi) =
  ajax("POST", url, headers, "", cont, doRedraw, kxi, true, data)

proc ajaxGet*(url: cstring; headers: openarray[(cstring, cstring)];
          doRedraw: bool = true,
          kxi: KaraxInstance = kxi): Future[(int, cstring)] =
    return newPromise() do (resolve: proc(response: (int, cstring))):
        ajaxGet(url, headers, proc (status: int, res: cstring) = resolve((status, res)))

proc ajaxPut*(url: cstring; headers: openarray[(cstring, cstring)];
          data: cstring;
          cont: proc (httpStatus: int, response: cstring);
          doRedraw: bool = true,
          kxi: KaraxInstance = kxi) =
  ajax("PUT", url, headers, data, cont, doRedraw, kxi)

proc ajaxDelete*(url: cstring; headers: openarray[(cstring, cstring)];
          cont: proc (httpStatus: int, response: cstring);
          doRedraw: bool = true,
          kxi: KaraxInstance = kxi) =
  ajax("DELETE", url, headers, nil, cont, doRedraw, kxi)
proc test() {.async.} =
    var (status, res) = await ajaxGet("https://httpbin.org/get", @[])
    echo res
test()
