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

Modules are a tool for separating your logic. You can create as many modules as you want and embed them in each other. Modules are zero-cost, since the code from them is simply substituted during compilation.

```nim
module admin:
  txt ["/ban", "/kick"]:
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

Since the code from the module is simply substituted, and filters are normal conditions, it is very easy to do preactions - you just perform the necessary actions before the main ones. However, for postactions, you need to use a special `after` macro.

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

Filters are divided into three types: simple, with arguments, and with preactions. The filter body can be anything, but the last expression must be of type bool.

```nim
# Simple filter
# Do not accept arguments and their name usually starts with "is".
defineFilter isAdmin:
  update.message.get().`from`.id == 123

# Filter with arguments
defineFilter chatId(cid: static[int]):
  update.message.get().chat.id == cid

# You can also use overloading
defineFilter chatId(cids: static[openArray[int]):
  update.message.get().chat.id in cids

# Filter with pre-action body
# Commonly used to injecting shortcuts.
defineFilter isInline, update.inline_query.isSome():
  let inline_query {.inject, used.} = update.inline_query.get()
```

### [Builtin filters](https://github.com/gabbhack/tim/blob/master/src/tim/private/filters.nim)
