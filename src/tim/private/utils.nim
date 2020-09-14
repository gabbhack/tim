import json


proc withoutNull*(x: JsonNode): JsonNode {.inline.} =
    case x.kind
    of JObject:
        result = copy(x)
        for k, v in x:
            case v.kind
            of JNull:
                result.delete(k)
            of JObject:
                result[k] = v.withoutNull()
            of JArray:
                var s = newJArray()
                for i in v:
                    s.add(i.withoutNull())
                result[k] = s
            else:
                discard
    of JArray:
        result = newJArray()
        for i in x:
            result.add(i.withoutNull())
    of JInt, JString, JFloat, JBool:
        result = x
    else:
        discard
