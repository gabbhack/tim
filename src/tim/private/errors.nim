import strutils


type
    TelegramError* = object of CatchableError
        ## Base object for Telegram's errors

    UnknownError* = object of TelegramError
        ## Occurs when an unknown error occurs

    BotBlocked* = object of TelegramError
        ## Occurs when the bot tries to send message to user who blocked the bot

    MessageNotModified* = object of TelegramError
        ## Occurs when bot tries to modify a message without modification content

    MessageIdInvalid* = object of TelegramError
        ## Occurs when bot tries to forward or delete a message which was deleted

    MessageToForwardNotFound* = object of TelegramError
        ## Occurs when bot tries to forward a message which does not exists

    MessageToDeleteNotFound* = object of TelegramError
        ## Occurs when bot tries to delete a message which does not exists

    MessageTextIsEmpty* = object of TelegramError
        ## Occurs when bot tries to send a text message without text

    MessageCantBeEdited* = object of TelegramError
        ## Occurs when bot tries to edit a message after long time

    MessageCantBeDeleted* = object of TelegramError
        ## Occurs when bot tries to delete a someone else's message in group where
        ## it does not have enough rights

    MessageToEditNotFound* = object of TelegramError
        ## Occurs when bot tries to edit a message which does not exists

    MessageToReplyNotFound* = object of TelegramError
        ## Occurs when bot tries to reply to a message which does not exists

    MessageIdentifierNotSpecified* = object of TelegramError
        ## Occurs when bot tries to

    MessageIsTooLong* = object of TelegramError
        ## Occurs when bot tries to send a message with text size greater then
        ## 4096 symbols
    
    ToMuchMessages* = object of TelegramError
        ## Occurs when bot tries to send media group with more than 10 items
    
    PollHasAlreadyClosed* = object of TelegramError
        ## Occurs when bot tries to stop poll that has already been stopped
    
    PollMustHaveMoreOptions* = object of TelegramError
        ## Occurs when bot tries to send poll with less than 2 options
    
    PollCantHaveMoreOptions* = object of TelegramError
        ## Occurs when bot tries to send poll with more than 10 options

    PollOptionsMustBeNonEmpty* = object of TelegramError
        ## Occurs when bot tries to send poll with empty option (without text)
    
    PollQuestionMustBeNonEmpty* = object of TelegramError
        ## Occurs when bot tries to send poll with empty question (without text)
    
    PollOptionsLengthTooLong* = object of TelegramError
        ## Occurs when bot tries to send poll with total size of options more than
        ## 100 symbols
    
    PollQuestionLengthTooLong* = object of TelegramError
        ## Occurs when bot tries to send poll with question size more than 255 symbols
    
    MessageWithPollNotFound* = object of TelegramError
        ## Occurs when bot tries to stop poll with message without poll
    
    MessageIsNotAPoll* = object of TelegramError
        ## Occurs when bot tries to stop poll with message without poll
    
    ChatNotFound* = object of TelegramError
        ## Occurs when bot tries to send a message to chat in which it is not a member
    
    UserNotFound* = object of TelegramError
        ## Occurs when bot tries to send method with unknown user_id
    
    ChatDescriptionIsNotModified* = object of TelegramError
        ## Occurs when bot tries to modify chat description with same text as in the current description
    
    InvalidQueryID* = object of TelegramError
        ## Occurs when bot tries to answer to query after timeout expire
    
    ButtonURLInvalid* = object of TelegramError
        ## Occurs when bot tries to send InlineKeyboardMarkup with invalid button url
    
    ButtonDataInvalid* = object of TelegramError
        ## Occurs when bot tries to send button with data size more than 64 bytes
    
    TextButtonsAreUnallowed* = object of TelegramError
        ## Occurs when bot tries to send button with data size == 0
    
    WrongFileID* = object of TelegramError
        ## Occurs when bot tries to get file by wrong file id
    
    GroupDeactivated* = object of TelegramError
        ## Occurs when bot tries to do some with group which was deactivated
    
    PhotoAsInputFileRequired* = object of TelegramError
        ## Occurs when bot tries to set chat photo from file ID
    
    InvalidStickersSet* = object of TelegramError
        ## Occurs when bot tries to add sticker to stickerset by invalid name
    
    NotEnoughRightsToPinMessage* = object of TelegramError
        ## Occurs when bot tries to pin a message without rights to pin in this chat
    
    MethodNotAvailableInPrivateChats* = object of TelegramError
        ## Occurs when bot tries to use method in group which is allowed only in a supergroup or channel
    
    CantDemoteChatCreator* = object of TelegramError
        ## Occurs when bot tries to demote chat creator

    CantRestrictSelf* = object of TelegramError
        ## Occurs when bot tries to restrict self in group chats
    
    NotEnoughRightsToRestrict* = object of TelegramError
        ## Occurs when bot tries to restrict chat member without rights to restrict in this chat
    
    WebhookRequireHTTPS* = object of TelegramError
        ## Occurs when bot tries set webhook to protocol other than HTTPS
    
    BadWebhookPort* = object of TelegramError
        ## Occurs when bot tries to set webhook to port other than 80, 88, 443 or 8443
    
    UnknownHost* = object of TelegramError
        ## Occurs when bot tries to set webhook to unknown host
    
    CantParseUrl* = object of TelegramError
        ## Occurs when bot tries to set webhook to invalid URL
    
    CantParseEntities* = object of TelegramError
        ## Occurs when bot tries to send message with unfinished entities
    
    CantGetUpdates* = object of TelegramError
        ## Occurs when bot tries to use getUpdates while webhook is active
    
    BotKicked* = object of TelegramError
        ## Occurs when bot tries to do some in group where bot was kicked
    
    UserDeactivated* = object of TelegramError
        ## Occurs when bot tries to send message to deactivated user
    
    CantInitiateConversation* = object of TelegramError
        ## Occurs when you tries to initiate conversation with a user
    
    CantTalkWithBots* = object of TelegramError
        ## Occurs when you tries to send message to bot
    
    WrongHTTPurl* = object of TelegramError
        ## Occurs when bot tries to send button with invalid http url
    
    TerminatedByOtherGetUpdates* = object of TelegramError
        ## Occurs when bot tries GetUpdate before the timeout. Make sure that only one Updater is running

    InvalidFileId* = object of TelegramError
        ## Occurs when bot tries to get file by invalid file id

    MigrateToChatId* = object of TelegramError
        ## The group has been migrated to a supergroup with the specified identifier
    
    RetryAfter* = object of TelegramError
        ## In case of exceeding flood control, the number of seconds left to wait before the request can be repeated


proc raiseError*(description: string) =
    case description
    of "Forbidden: bot was blocked by the user": raise newException(BotBlocked, description)
    of "Bad Request: message is not modified: specified new message content and reply markup are exactly the same as a current content and reply markup of the message": raise newException(MessageNotModified, description)
    of "Bad Request: MESSAGE_ID_INVALID": raise newException(MessageIdInvalid, description)
    of "Bad Request: message to forward not found": raise newException(MessageToForwardNotFound, description)
    of "Bad Request: message to delete not found": raise newException(MessageToDeleteNotFound, description)
    of "Bad Request: message text is empty": raise newException(MessageTextIsEmpty, description)
    of "Bad Request: message can't be edited": raise newException(MessageCantBeEdited, description)
    of "Bad Request: message can't be deleted": raise newException(MessageCantBeDeleted, description)
    of "Bad Request: message to edit not found": raise newException(MessageToEditNotFound, description)
    of "Bad Request: reply message not found": raise newException(MessageToReplyNotFound, description)
    of "Bad Request: message identifier is not specified": raise newException(MessageIdentifierNotSpecified, description)
    of "Bad Request: message is too long": raise newException(MessageIsTooLong, description)
    of "Bad Request: Too much messages to send as an album": raise newException(ToMuchMessages, description)
    of "Bad Request: poll has already been closed": raise newException(PollHasAlreadyClosed, description)
    of "Bad Request: poll must have at least 2 option": raise newException(PollMustHaveMoreOptions, description)
    of "Bad Request: poll can't have more than 10 options": raise newException(PollCantHaveMoreOptions, description)
    of "Bad Request: poll options must be non-empty": raise newException(PollOptionsMustBeNonEmpty, description)
    of "Bad Request: poll question must be non-empty": raise newException(PollQuestionMustBeNonEmpty, description)
    of "Bad Request: poll options length must not exceed 100": raise newException(PollOptionsLengthTooLong, description)
    of "Bad Request: poll question length must not exceed 255": raise newException(PollQuestionLengthTooLong, description)
    of "Bad Request: message with poll to stop not found": raise newException(MessageWithPollNotFound, description)
    of "Bad Request: message is not a poll": raise newException(MessageIsNotAPoll, description)
    of "Bad Request: chat not found": raise newException(ChatNotFound, description)
    of "Bad Request: user not found": raise newException(UserNotFound, description)
    of "Bad Request: chat description is not modified": raise newException(ChatDescriptionIsNotModified, description)
    of "Bad Request: query is too old and response timeout expired or query id is invalid": raise newException(InvalidQueryID, description)
    of "Bad Request: BUTTON_URL_INVALID": raise newException(ButtonURLInvalid, description)
    of "Bad Request: BUTTON_DATA_INVALID": raise newException(ButtonDataInvalid, description)
    of "Bad Request: can't parse inline keyboard button: Text buttons are unallowed in the inline keyboard": raise newException(TextButtonsAreUnallowed, description)
    of "Bad Request: wrong file id": raise newException(WrongFileID, description)
    of "Bad Request: group is deactivated": raise newException(GroupDeactivated, description)
    of "Bad Request: Photo should be uploaded as an InputFile": raise newException(PhotoAsInputFileRequired, description)
    of "Bad Request: STICKERSET_INVALID": raise newException(InvalidStickersSet, description)
    of "Bad Request: not enough rights to pin a message": raise newException(NotEnoughRightsToPinMessage, description)
    of "Bad Request: method is available only for supergroups and channel": raise newException(MethodNotAvailableInPrivateChats, description)
    of "Bad Request: can't demote chat creator": raise newException(CantDemoteChatCreator, description)
    of "Bad Request: can't restrict self": raise newException(CantRestrictSelf, description)
    of "Bad Request: not enough rights to restrict/unrestrict chat member": raise newException(NotEnoughRightsToRestrict, description)
    of "Bad Request: bad webhook: HTTPS url must be provided for webhook": raise newException(WebhookRequireHTTPS, description)
    of "Bad Request: bad webhook: Webhook can be set up only on ports 80, 88, 443 or 8443": raise newException(BadWebhookPort, description)
    of "Bad Request: bad webhook: Failed to resolve host: Name or service not known": raise newException(UnknownHost, description)
    of "Bad Request: can't parse URL": raise newException(CantParseUrl, description)
    of "Bad Request: can't parse entities": raise newException(CantParseEntities, description)
    of "can't use getUpdates method while webhook is active": raise newException(CantGetUpdates, description)
    of "Unauthorized: bot was kicked from a chat": raise newException(BotKicked, description)
    of "Unauthorized: user is deactivated": raise newException(UserDeactivated, description)
    of "Unauthorized: bot can't initiate conversation with a user": raise newException(CantInitiateConversation, description)
    of "Unauthorized: bot can't send messages to bots": raise newException(CantTalkWithBots, description)
    of "Bad Request: wrong HTTP URL": raise newException(WrongHTTPurl, description)
    of "Conflict: terminated by other getUpdates request; make sure that only one bot instance is running": raise newException(TerminatedByOtherGetUpdates, description)
    of "Bad Request: invalid file id": raise newException(InvalidFileId, description)
    elif description.startsWith("The group has been migrated to a supergroup with ID "): raise newException(MigrateToChatId, description[52 .. description.len-1])
    elif description.startsWith("Retry after "): raise newException(RetryAfter, description[12 .. description.len-8])
    else: raise newException(UnknownError, description & "\nPlease report this error to the library developer.")
