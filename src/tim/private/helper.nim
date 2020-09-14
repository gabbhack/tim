import options
import httpclient

import types


proc newBot*(defaultToken: string, proxy: Proxy = nil, requestTimeout: int = 5*60*1000, defaultAPI: string = "https://api.telegram.org/bot$1/$2"): Bot =
    result = new(Bot)
    result.defaultAPI = defaultAPI
    result.defaultToken = defaultToken
    result.proxy = proxy
    result.requestTimeout = requestTimeout


proc newFSInputFile*(file: string): FSInputFile =
    FSInputFile(content: file)


template answer*(message: Message, text: string, parse_mode = none(string), disable_web_page_preview = none(bool), disable_notification = none(bool), reply_to_message_id = none(int)): untyped {.dirty.} =
    bot.sendMessage(message.chat.id, text, parse_mode, disable_web_page_preview, disable_notification, reply_to_message_id)


template answer*(message: Message, text: string, reply_markup: KeyboardMarkup, parse_mode = none(string), disable_web_page_preview = none(bool), disable_notification = none(bool), reply_to_message_id = none(int)): untyped {.dirty.} =
    bot.sendMessage(message.chat.id, text, reply_markup, parse_mode, disable_web_page_preview, disable_notification, reply_to_message_id)


template answer*(callback_query: CallbackQuery, text = none(string), show_alert = none(bool), url = none(string), cache_time = none(int)): untyped {.dirty.} =
    bot.answerCallbackQuery(callback_query.id, text, show_alert, url, cache_time)
