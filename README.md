# tim

This is the MVP of an idea that I decided to implement on Nim. The project will most likely not be developed.

The main idea of the project is to make effective routing. In most frameworks, handlers are brute-forced, and the same filters are executed several times.

In tim, all filters are expanded to normal conditions at compile time. So

```nim
isMsg:
  isText:
    txt "/start":
      ...
```

turns into something like

```nim
if update.message.isSome():
  if update.message.get().text.isSome():
    if update.message.text.get() == "/start":
      ...
```

This means that the filter will be executed at most once.

## Installation

`nimble install https://github.com/gabbhack/tim`

## Examples

### Echo bot

```nim
import asyncdispatch, options, logging
import tim

addHandler(newConsoleLogger(lvlInfo))

let bot = newBot("TOKEN")

module general:
    isMsg:
        isText:
            dawait message.answer(message.text.get())

bot.poll(asPollingHandler(general))
```

### Modules

```nim
module admin:
  txt "/ban", "/kick":
    userId 123:
      txt "/ban":
        dawait message.answer("Ban!")
      txt "/kick":
        dawait message.answer("Kick!")
    dawait message.answer("You are not admin")

module base:
  txt "/start":
    dawait message.answer("Start!")

module general:
  isMsg:
    isText:
      admin
      base
```

### Pre and post actions

```nim
module base:
  txt "/start":
    after:
      echo "pre action on /start cmd"
      dawait message.answer("Start!")
    do:
      echo "post action on /start cmd"

module general:
  isMsg:
    isText:
        after:
            echo "pre action on any text"
            base
        do:
            echo "post action on any text"
```

### Create own filters

```nim
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
