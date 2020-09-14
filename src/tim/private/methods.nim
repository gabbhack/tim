import asyncdispatch, httpclient, strutils, options, logging, json

import types, client, utils


proc magicAdd(data: MultipartData, name: string, x: string | SomeInteger | bool) {.inline.} =
    data.add({name: $x})


proc magicAdd(data: MultipartData, name: string, x: InputFile) {.inline.} =
    when x is FSInputFile:
        data.addFiles({name: x.content})
    else:
        data.add({name: x.content})


proc magicAdd(data: MultipartData, name: string, x: seq) {.inline.} =
    data.add({name: $(%x)})


proc magicAdd(data: MultipartData, name: string, x: InlineKeyboardMarkup) {.inline.} =
    data.add({name: $((%(x)).withoutNull())})


proc magicAdd(data: MultipartData, name: string, x: ReplyKeyboardMarkup) {.inline.} =
    data.add({name: $((%(x)).withoutNull())})


proc magicAdd(data: MultipartData, name: string, x: ReplyKeyboardRemove) {.inline.} =
    data.add({name: $((%(x)).withoutNull())})


proc magicAdd(data: MultipartData, name: string, x: ForceReply) {.inline.} =
    data.add({name: $((%(x)).withoutNull())})


proc callMethod*[T](bot: Bot, apiMethod: string, data: MultipartData = nil): Future[T] {.async, inline.} =
    when declaredInScope(magicTokenRewrite):
        let token = magicTokenRewrite
    else:
        let token = bot.defaultToken

    debug("Call $1 method" % apiMethod)
    return await makeRequest[T](bot.defaultAPI % [token, apiMethod], data, bot.requestTimeout, bot.proxy)


proc getUpdates*(bot: Bot, offset = none(int), limit = none(int), timeout = none(int), allowed_updates = none(seq[string])): Future[seq[Update]] {.async.} =
    let data = newMultipartData()
    if offset.isSome():
        data.magicAdd("offset", offset.get())
    if limit.isSome():
        data.magicAdd("limit", limit.get())
    if timeout.isSome():
        data.magicAdd("timeout", timeout.get())
    if allowed_updates.isSome():
        data.magicAdd("allowed_updates", allowed_updates.get())
    return await bot.callMethod[:seq[Update]]("getUpdates", data)


proc sendMessage*(bot: Bot, chat_id: SomeInteger | string, text: string, parse_mode = none(string), disable_web_page_preview = none(bool), disable_notification = none(bool), reply_to_message_id = none(int)): Future[Message] {.async.} =
    let data = newMultipartData()
    data.magicAdd("chat_id", chat_id)
    data.magicAdd("text", text)
    if parse_mode.isSome():
        data.magicAdd("parse_mode", parse_mode.get())
    if disable_web_page_preview.isSome():
        data.magicAdd("disable_web_page_preview", disable_web_page_preview.get())
    if disable_notification.isSome():
        data.magicAdd("disable_notification", disable_notification.get())
    if reply_to_message_id.isSome():
        data.magicAdd("reply_to_message_id", reply_to_message_id.get())
    return await bot.callMethod[:Message]("sendMessage", data)


proc sendMessage*(bot: Bot, chat_id: SomeInteger | string, text: string, reply_markup: KeyboardMarkup, parse_mode = none(string), disable_web_page_preview = none(bool), disable_notification = none(bool), reply_to_message_id = none(int)): Future[Message] {.async.} =
    let data = newMultipartData()
    data.magicAdd("chat_id", chat_id)
    data.magicAdd("text", text)
    data.magicAdd("reply_markup", reply_markup)
    if parse_mode.isSome():
        data.magicAdd("parse_mode", parse_mode.get())
    if disable_web_page_preview.isSome():
        data.magicAdd("disable_web_page_preview", disable_web_page_preview.get())
    if disable_notification.isSome():
        data.magicAdd("disable_notification", disable_notification.get())
    if reply_to_message_id.isSome():
        data.magicAdd("reply_to_message_id", reply_to_message_id.get())
    return await bot.callMethod[:Message]("sendMessage", data)


proc answerCallbackQuery*(bot: Bot, callback_query_id: string, text = none(string), show_alert = none(bool), url = none(string), cache_time = none(int)): Future[bool] {.async.} =
    let data = newMultipartData()
    data.magicAdd("callback_query_id", callback_query_id)
    if text.isSome():
        data.magicAdd("text", text.get())
    if show_alert.isSome():
        data.magicAdd("show_alert", show_alert.get())
    if url.isSome():
        data.magicAdd("url", url.get())
    if cache_time.isSome():
        data.magicAdd("cache_time", cache_time.get())
    return await bot.callMethod[:bool]("answerCallbackQuery", data)
