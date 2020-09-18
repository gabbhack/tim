import macros, asyncdispatch


template module*(title: untyped{ident}, body: typed): untyped =
    template title* =
        body


template router*(title: untyped{ident}, body: typed) =
    template name*: untyped =
        proc name(): Future[bool] {.async.} =
            block:
                body
                break
        let r = name()
        yield r
        if r.read():
            result = true
            break


macro defineFilter*(title: untyped{ident}, filterBody: untyped): untyped =
    result = quote do:
        template `title`*(actions: untyped): untyped =
            if `filterBody`:
                actions
                result = true
                break


macro defineFilter*(title: untyped{ident}, filterBody, actionsBody: untyped): untyped =
    result = quote do:
        template `title`*(actions: untyped): untyped =
            if `filterBody`:
                `actionsBody`
                actions
                result = true
                break


macro defineFilter*(title: untyped{nkObjConstr}, filterBody: untyped): untyped =
    result = newTree(nnkStmtList)
    let postfix = newTree(nnkPostfix, newIdentNode("*"), title[0])
    var formalParams = newTree(nnkFormalParams, newIdentNode("untyped"))
    for i in title:
        if i.kind == nnkExprColonExpr:
            var identDefs = newTree(nnkIdentDefs)
            i.copyChildrenTo(identDefs)
            identDefs.add(newEmptyNode())
            formalParams.add(identDefs)
    formalParams.add(newTree(nnkIdentDefs, newIdentNode("actions"), newIdentNode("untyped"), newEmptyNode()))

    let templateBody = quote do:
        if `filterBody`:
            actions
            result = true
            break

    let tmp = newTree(
        nnkTemplateDef, 
        postfix, 
        newEmptyNode(), 
        newEmptyNode(), 
        formalParams, 
        newEmptyNode(), 
        newEmptyNode(), 
        newTree(nnkStmtList, templateBody)
    )
    result.add(tmp)


template defineInjector*(title: untyped{ident}, name: untyped{ident}, injectorBody: typed) =
    template `title`* =
        let `name` {.inject.} = `injectorBody`


template withToken*(token: string, body: typed) =
    block:
        let magicTokenRewrite {.inject.} = token
        body


template mawait*(future: Future) =
    # custom magic await because normal doesnt work in templates
    let x = future
    yield x
    x.read()


template dawait*(future: Future) =
    discard mawait(future)


template after*(body, after: typed) =
    # defer doesnt work because of https://github.com/nim-lang/Nim/issues/15243
    try:
        block:
            body
    finally:
        after


template asPollingHandler*(body: untyped): untyped {.dirty.} =
    # use block and break because of https://github.com/nim-lang/Nim/issues/15242
    (proc (bot: Bot, update: Update): Future[bool] {.async.} =
        block:
            let pollingMode {.inject, used.} = true
            body
    )
