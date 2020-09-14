import sets

import magic


defineFilter isMsg, update.message.isSome():
    let message {.inject, used.} = update.message.get()


defineFilter isCb, update.callback_query.isSome():
    let callback_query {.inject, used.} = update.callback_query.get()


defineFilter isCbData:
    update.callback_query.get().data.isSome()


defineFilter isText:
    update.message.get().text.isSome()


defineFilter userId(uid: static[int]):
    update.message.get().`from`.get().id == uid


defineFilter txt(txt: static[string]):
    update.message.get().text.get() == txt


defineFilter txt(txts: static[openArray[string]]):
    update.message.get().text.get() in txts


defineFilter data(txt: static[string]):
    update.callback_query.get().data.get() == txt


defineFilter data(txts: static[openArray[string]]):
    update.callback_query.get().data.get() in txts


defineFilter filter(condition: bool):
    condition
