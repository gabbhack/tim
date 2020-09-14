import asyncdispatch
import logging
import options
from net import TimeoutError

import methods
import types


var polling = false


proc stopPolling*() =
    if polling:
        warn("Stop polling...")
        polling = false


proc shutdown*() {.noconv.} =
    warn("Shutdown gracefully...")
    if polling:
        stopPolling()
        drain()
        warn("Exit")
        quit(1)


proc skipUpdates*(bot: Bot) {.async, inline.} =
    asyncCheck bot.getUpdates(offset=some(-1), timeout=some(1))


proc processPollingUpdates(bot: Bot, handler: PollingHandler, updates: seq[Update]) {.inline.} =
    for i in updates:
        asyncCheck handler(bot, i)


proc startPolling*(bot: Bot, handler: PollingHandler, timeout: Option[int] = some(300), limit: Option[int] = none(int), allowed_updates: Option[seq[string]] = none(seq[string]), errorSleep: int = 20*1000) {.async.} =
    info("Start polling...")
    polling = true

    var offset = 0
    try:
        while polling:
            try:
                let updates = await bot.getUpdates(some(offset), limit, timeout, allowed_updates)
                if updates.len != 0:
                    offset = int(updates[updates.high].update_id + 1)
                    bot.processPollingUpdates(handler, updates)
            except TimeoutError:
                error("Request timeout when getting updates")
                await sleepAsync(errorSleep)
            except:
                error("Cause error when getting updates: ", getCurrentExceptionMsg())
                await sleepAsync(errorSleep)
    finally:
        warn("Polling is stoped")


proc poll*(bot: Bot, handler: PollingHandler, timeout: Option[int] = some(300), limit: Option[int] = none(int), allowed_updates: Option[seq[string]] = none(seq[string]), gracefulShutdown: static[bool] = true, errorSleep: int = 20*1000) =
    when gracefulShutdown:
        setControlCHook(shutdown)

    asyncCheck bot.startPolling(handler, timeout, limit, allowed_updates, errorSleep)
    runForever()
