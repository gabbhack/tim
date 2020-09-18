# tim

## Installation

`nimble install https://github.com/gabbhack/tim`

## Examples

### Echo bot

```nim
import tim

bot = newBot("TOKEN")

module base:
  isMsg:
    isText:
      dawait message.answer(message.text.get())

bot.poll(asPollingHandler(base))
```

### Create own filters

```nim
import tim

# Simple filter
defineFilter isAdmin:
  update.message.get().`from`.id == 123

# Filter with arguments
defineFilter chatId(cid: static[int]):
  update.message.get().chat.id == cid

# Filter with pre-action body
defineFilter isInline, update.inline_query.isSome():
  let inline_query {.inject, used.} = update.inline_query.get()
```

### [Builtin filters](https://github.com/gabbhack/tim/blob/master/src/tim/private/filters.nim)
