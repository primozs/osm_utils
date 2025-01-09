# https://osm-queries.ldodds.com/tutorial/index.html
# https://overpass-turbo.eu/
import std/asyncdispatch
import std/httpclient
import std/json
import std/strutils

const OverpassUrl = "https://overpass-api.de/api/interpreter"

proc overpassQuery*(query: string, url: string = OverpassUrl): JsonNode {.raises: [].} =
  var client: HttpClient
  try:
    client = newHttpClient()
    client.headers = newHttpHeaders({"Content-Type": "application/json"})
    let res = client.post(url = url, body = "data=" & query)
    let resJson = res.body.parseJson()
    result = resJson
  except Exception as e:
    echo e.repr
  finally:
    try:
      client.close()
    except:
      echo getCurrentExceptionMsg()


proc overpassQueryAsync*(query: string, url: string = OverpassUrl): Future[
    JsonNode] {.async.} =
  var client: AsyncHttpClient
  try:
    client = newAsyncHttpClient()
    client.headers = newHttpHeaders({"Content-Type": "application/json"})
    let res = await client.post(url = url, body = "data=" & query)
    let resBody = await body (res)
    let resJson = resBody.parseJson()
    result = resJson
  except Exception as e:
    echo e.repr
  finally:
    client.close()
