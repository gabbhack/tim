from net import TimeoutError
import asyncdispatch, httpclient, json, logging

import errors, types


const userAgent = "tim/0.0.1"


template withClient(actions: untyped): untyped {.dirty.} =
    let client = newAsyncHttpClient(userAgent=userAgent, proxy=proxy)

    try:
        actions
    finally:
        client.close()


proc parseResult[T](body: string): Result[T] {.inline.} =
    debug("Request result body: ", body)
    return parseJson(body).to(Result[T])


proc makeRequest*[T](endpoint: string, data: MultipartData = nil, timeout: int = 5*1000*60, proxy: Proxy = nil): Future[T] {.async, inline.} =
    withClient:
        let rFuture = client.post(endpoint, multipart=data)

        if await withTimeout(rFuture, timeout):
            let r = rFuture.read()
            if r.code == Http200 or r.code == Http400:
                let apiResult = parseResult[T](await r.body)
                if apiResult.ok:
                    return apiResult.result.get()
                else:
                    raiseError(apiResult.description.get())
            else:
                raise newException(IOError, r.status)
        else:
            raise newException(TimeoutError, "Request timed out")
