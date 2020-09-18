import asyncdispatch
import httpclient
import options


type
    PollingHandler* = proc(bot: Bot, update: Update): Future[bool] {.async, gcsafe.}

    Bot* = ref object
        defaultAPI*: string
        defaultToken*: string
        proxy*: Proxy
        requestTimeout*: int

    Result*[T] = object
        ## This object represents a request result

        ok*: bool
        description*: Option[string]
        error_code*: Option[int32]
        parameters*: Option[ResponseParameters]
        result*: Option[T]

    Update* = object
        ## This object represents an incoming update.
        ## At most one of the optional parameters can be present in any given update.
        ## 
        ## Source: https://core.telegram.org/bots/api#update
        
        update_id*: int32
        message*: Option[Message]
        edited_message*: Option[Message]
        channel_post*: Option[Message]
        edited_channel_post*: Option[Message]
        inline_query*: Option[InlineQuery]
        chosen_inline_result*: Option[ChosenInlineResult]
        callback_query*: Option[CallbackQuery]
        shipping_query*: Option[ShippingQuery]
        pre_checkout_query*: Option[PreCheckoutQuery]
        poll*: Option[Poll]
        poll_answer*: Option[PollAnswer]
        
    WebhookInfo* = object
        ## Contains information about the current status of a webhook.
        ## 
        ## Source: https://core.telegram.org/bots/api#webhookinfo
        
        url*: string
        has_custom_certificate*: bool
        pending_update_count*: int32
        last_error_date*: Option[int32]
        last_error_message*: Option[string]
        max_connections*: Option[int32]
        allowed_updates*: Option[seq[string]]
        
    User* = object
        ## This object represents a Telegram user or bot.
        ## 
        ## Source: https://core.telegram.org/bots/api#user
        
        id*: int32
        is_bot*: bool
        first_name*: string
        last_name*: Option[string]
        username*: Option[string]
        language_code*: Option[string]
        can_join_groups*: Option[bool]
        can_read_all_group_messages*: Option[bool]
        supports_inline_queries*: Option[bool]
        
    Chat* = object
        ## This object represents a chat.
        ## 
        ## Source: https://core.telegram.org/bots/api#chat
        
        id*: int64
        `type`*: string
        title*: Option[string]
        username*: Option[string]
        first_name*: Option[string]
        last_name*: Option[string]
        photo*: Option[ChatPhoto]
        description*: Option[string]
        invite_link*: Option[string]
        pinned_message*: Option[ref Message]
        permissions*: Option[ChatPermissions]
        slow_mode_delay*: Option[int32]
        sticker_set_name*: Option[string]
        can_set_sticker_set*: Option[bool]

    Message* = object
        ## This object represents a message.
        ## 
        ## Source: https://core.telegram.org/bots/api#message
        
        message_id*: int32
        date*: int32
        chat*: Chat
        `from`*: Option[User]
        forward_from*: Option[User]
        forward_from_chat*: Option[Chat]
        forward_from_message_id*: Option[int32]
        forward_signature*: Option[string]
        forward_sender_name*: Option[string]
        forward_date*: Option[int32]
        reply_to_message*: Option[ref Message]
        via_bot*: Option[User]
        edit_date*: Option[int32]
        media_group_id*: Option[string]
        author_signature*: Option[string]
        text*: Option[string]
        entities*: Option[seq[MessageEntity]]
        animation*: Option[Animation]
        audio*: Option[Audio]
        document*: Option[Document]
        photo*: Option[seq[PhotoSize]]
        sticker*: Option[Sticker]
        video*: Option[Video]
        video_note*: Option[VideoNote]
        voice*: Option[Voice]
        caption*: Option[string]
        caption_entities*: Option[seq[MessageEntity]]
        contact*: Option[Contact]
        dice*: Option[Dice]
        game*: Option[Game]
        poll*: Option[Poll]
        venue*: Option[Venue]
        location*: Option[Location]
        new_chat_members*: Option[seq[User]]
        left_chat_member*: Option[User]
        new_chat_title*: Option[string]
        new_chat_photo*: Option[seq[PhotoSize]]
        delete_chat_photo*: Option[bool]
        group_chat_created*: Option[bool]
        supergroup_chat_created*: Option[bool]
        channel_chat_created*: Option[bool]
        migrate_to_chat_id*: Option[int64]
        migrate_from_chat_id*: Option[int64]
        pinned_message*: Option[ref Message]
        invoice*: Option[Invoice]
        successful_payment*: Option[SuccessfulPayment]
        connected_website*: Option[string]
        passport_data*: Option[PassportData]
        reply_markup*: Option[InlineKeyboardMarkup]
        
    MessageEntity* = object
        ## This object represents one special entity in a text message. For example, hashtags, usernames,
        ## URLs, etc.
        ## 
        ## Source: https://core.telegram.org/bots/api#messageentity
        
        `type`*: string
        offset*: int32
        length*: int32
        url*: Option[string]
        user*: Option[User]
        language*: Option[string]
        
    PhotoSize* = object
        ## This object represents one size of a photo or a file / sticker thumbnail.
        ## 
        ## Source: https://core.telegram.org/bots/api#photosize
        
        file_id*: string
        file_unique_id*: string
        width*: int32
        height*: int32
        file_size*: Option[int32]
        
    Audio* = object
        ## This object represents an audio file to be treated as music by the Telegram clients.
        ## 
        ## Source: https://core.telegram.org/bots/api#audio
        
        file_id*: string
        file_unique_id*: string
        duration*: int32
        performer*: Option[string]
        title*: Option[string]
        mime_type*: Option[string]
        file_size*: Option[int32]
        thumb*: Option[PhotoSize]
        
    Document* = object
        ## This object represents a general file (as opposed to photos, voice messages and audio files).
        ## 
        ## Source: https://core.telegram.org/bots/api#document
        
        file_id*: string
        file_unique_id*: string
        thumb*: Option[PhotoSize]
        file_name*: Option[string]
        mime_type*: Option[string]
        file_size*: Option[int32]
        
    Video* = object
        ## This object represents a video file.
        ## 
        ## Source: https://core.telegram.org/bots/api#video
        
        file_id*: string
        file_unique_id*: string
        width*: int32
        height*: int32
        duration*: int32
        thumb*: Option[PhotoSize]
        mime_type*: Option[string]
        file_size*: Option[int32]
        
    Animation* = object
        ## This object represents an animation file (GIF or H.264/MPEG-4 AVC video without sound).
        ## 
        ## Source: https://core.telegram.org/bots/api#animation
        
        file_id*: string
        file_unique_id*: string
        width*: int32
        height*: int32
        duration*: int32
        thumb*: Option[PhotoSize]
        file_name*: Option[string]
        mime_type*: Option[string]
        file_size*: Option[int32]
        
    Voice* = object
        ## This object represents a voice note.
        ## 
        ## Source: https://core.telegram.org/bots/api#voice
        
        file_id*: string
        file_unique_id*: string
        duration*: int32
        mime_type*: Option[string]
        file_size*: Option[int32]
        
    VideoNote* = object
        ## This object represents a video message (available in Telegram apps as of v.4.0).
        ## 
        ## Source: https://core.telegram.org/bots/api#videonote
        
        file_id*: string
        file_unique_id*: string
        length*: int32
        duration*: int32
        thumb*: Option[PhotoSize]
        file_size*: Option[int32]
        
    Contact* = object
        ## This object represents a phone contact.
        ## 
        ## Source: https://core.telegram.org/bots/api#contact
        
        phone_number*: string
        first_name*: string
        last_name*: Option[string]
        user_id*: Option[int32]
        vcard*: Option[string]
        
    Location* = object
        ## This object represents a point on the map.
        ## 
        ## Source: https://core.telegram.org/bots/api#location
        
        longitude*: float
        latitude*: float
        
    Venue* = object
        ## This object represents a venue.
        ## 
        ## Source: https://core.telegram.org/bots/api#venue
        
        location*: Location
        title*: string
        address*: string
        foursquare_id*: Option[string]
        foursquare_type*: Option[string]
        
    PollOption* = object
        ## This object contains information about one answer option in a poll.
        ## 
        ## Source: https://core.telegram.org/bots/api#polloption
        
        text*: string
        voter_count*: int32
        
    PollAnswer* = object
        ## This object represents an answer of a user in a non-anonymous poll.
        ## 
        ## Source: https://core.telegram.org/bots/api#pollanswer
        
        poll_id*: string
        user*: User
        option_ids*: seq[int32]
        
    Poll* = object
        ## This object contains information about a poll.
        ## 
        ## Source: https://core.telegram.org/bots/api#poll
        
        id*: string
        question*: string
        options*: seq[PollOption]
        total_voter_count*: int32
        is_closed*: bool
        is_anonymous*: bool
        `type`*: string
        allows_multiple_answers*: bool
        correct_option_id*: Option[int32]
        explanation*: Option[string]
        explanation_entities*: Option[seq[MessageEntity]]
        open_period*: Option[int32]
        close_date*: Option[int32]
        
    Dice* = object
        ## This object represents an animated emoji that displays a random value.
        ## 
        ## Source: https://core.telegram.org/bots/api#dice
        
        emoji*: string
        value*: int32
        
    UserProfilePhotos* = object
        ## This object represent a user's profile pictures.
        ## 
        ## Source: https://core.telegram.org/bots/api#userprofilephotos
        
        total_count*: int32
        photos*: seq[seq[PhotoSize]]
        
    File* = object
        ## This object represents a file ready to be downloaded. The file can be downloaded via the link
        ## https://api.telegram.org/file/bot<token>/<file_path>. It is guaranteed that the link will be
        ## valid for at least 1 hour. When the link expires, a new one can be requested by calling
        ## getFile.
        ## Maximum file size to download is 20 MB
        ## 
        ## Source: https://core.telegram.org/bots/api#file
        
        file_id*: string
        file_unique_id*: string
        file_size*: Option[int32]
        file_path*: Option[string]

    ReplyKeyboardMarkup* = object
        ## This object represents a custom keyboard with reply options (see Introduction to bots for
        ## details and examples).
        ## 
        ## Source: https://core.telegram.org/bots/api#replykeyboardmarkup
        
        keyboard*: seq[seq[KeyboardButton]]
        resize_keyboard*: Option[bool]
        one_time_keyboard*: Option[bool]
        selective*: Option[bool]

    KeyboardButton* = object
        ## This object represents one button of the reply keyboard. For simple text buttons String can be
        ## used instead of this object to specify text of the button. Optional fields request_contact,
        ## request_location, and request_poll are mutually exclusive.
        ## Note: request_contact and request_location options will only work in Telegram versions
        ## released after 9 April, 2016. Older clients will display unsupported message.
        ## Note: request_poll option will only work in Telegram versions released after 23 January, 2020.
        ## Older clients will display unsupported message.
        ## 
        ## Source: https://core.telegram.org/bots/api#keyboardbutton
        
        text*: string
        request_contact*: Option[bool]
        request_location*: Option[bool]
        request_poll*: Option[KeyboardButtonPollType]
        
    KeyboardButtonPollType* = object
        ## This object represents type of a poll, which is allowed to be created and sent when the
        ## corresponding button is pressed.
        ## 
        ## Source: https://core.telegram.org/bots/api#keyboardbuttonpolltype
        
        `type`*: Option[string]
        
    ReplyKeyboardRemove* = object
        ## Upon receiving a message with this object, Telegram clients will remove the current custom
        ## keyboard and display the default letter-keyboard. By default, custom keyboards are displayed
        ## until a new keyboard is sent by a bot. An exception is made for one-time keyboards that are
        ## hidden immediately after the user presses a button (see ReplyKeyboardMarkup).
        ## 
        ## Source: https://core.telegram.org/bots/api#replykeyboardremove
        
        remove_keyboard*: Option[bool]
        selective*: Option[bool]
        
    InlineKeyboardMarkup* = object
        ## This object represents an inline keyboard that appears right next to the message it belongs
        ## to.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will display unsupported message.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinekeyboardmarkup
        
        inline_keyboard*: seq[seq[InlineKeyboardButton]]
        
    InlineKeyboardButton* = object
        ## This object represents one button of an inline keyboard. You must use exactly one of the
        ## optional fields.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinekeyboardbutton
        
        text*: string
        url*: Option[string]
        login_url*: Option[LoginUrl]
        callback_data*: Option[string]
        switch_inline_query*: Option[string]
        switch_inline_query_current_chat*: Option[string]
        callback_game*: Option[CallbackGame]
        pay*: Option[bool]
        
    LoginUrl* = object
        ## This object represents a parameter of the inline keyboard button used to automatically
        ## authorize a user. Serves as a great replacement for the Telegram Login Widget when the user is
        ## coming from Telegram. All the user needs to do is tap/click a button and confirm that they
        ## want to log in:
        ## Telegram apps support these buttons as of version 5.7.
        ## Sample bot: @discussbot
        ## 
        ## Source: https://core.telegram.org/bots/api#loginurl
        
        url*: string
        forward_text*: Option[string]
        bot_username*: Option[string]
        request_write_access*: Option[bool]
        
    CallbackQuery* = object
        ## This object represents an incoming callback query from a callback button in an inline
        ## keyboard. If the button that originated the query was attached to a message sent by the bot,
        ## the field message will be present. If the button was attached to a message sent via the bot
        ## (in inline mode), the field inline_message_id will be present. Exactly one of the fields data
        ## or game_short_name will be present.
        ## NOTE: After the user presses a callback button, Telegram clients will display a progress bar
        ## until you call answerCallbackQuery. It is, therefore, necessary to react by calling
        ## answerCallbackQuery even if no notification to the user is needed (e.g., without specifying
        ## any of the optional parameters).
        ## 
        ## Source: https://core.telegram.org/bots/api#callbackquery
        
        id*: string
        `from`*: User
        chat_instance*: string
        message*: Option[Message]
        inline_message_id*: Option[string]
        data*: Option[string]
        game_short_name*: Option[string]
        
    ForceReply* = object
        ## Upon receiving a message with this object, Telegram clients will display a reply interface to
        ## the user (act as if the user has selected the bot's message and tapped 'Reply'). This can be
        ## extremely useful if you want to create user-friendly step-by-step interfaces without having to
        ## sacrifice privacy mode.
        ## Example: A poll bot for groups runs in privacy mode (only receives commands, replies to its
        ## messages and mentions). There could be two ways to create a new poll:
        ## 
        ## Explain the user how to send a command with parameters (e.g. /newpoll question answer1
        ## answer2). May be appealing for hardcore users but lacks modern day polish.
        ## Guide the user through a step-by-step process. 'Please send me your question', 'Cool, now
        ## let's add the first answer option', 'Great. Keep adding answer options, then send /done when
        ## you're ready'.
        ## The last option is definitely more attractive. And if you use ForceReply in your bot's
        ## questions, it will receive the user's answers even if it only receives replies, commands and
        ## mentions — without any extra work for the user.
        ## 
        ## Source: https://core.telegram.org/bots/api#forcereply
        
        force_reply*: bool
        selective*: Option[bool]
        
    ChatPhoto* = object
        ## This object represents a chat photo.
        ## 
        ## Source: https://core.telegram.org/bots/api#chatphoto
        
        small_file_id*: string
        small_file_unique_id*: string
        big_file_id*: string
        big_file_unique_id*: string
        
    ChatMember* = object
        ## This object contains information about one member of a chat.
        ## 
        ## Source: https://core.telegram.org/bots/api#chatmember
        
        user*: User
        status*: string
        custom_title*: Option[string]
        until_date*: Option[int32]
        can_be_edited*: Option[bool]
        can_post_messages*: Option[bool]
        can_edit_messages*: Option[bool]
        can_delete_messages*: Option[bool]
        can_restrict_members*: Option[bool]
        can_promote_members*: Option[bool]
        can_change_info*: Option[bool]
        can_invite_users*: Option[bool]
        can_pin_messages*: Option[bool]
        is_member*: Option[bool]
        can_send_messages*: Option[bool]
        can_send_media_messages*: Option[bool]
        can_send_polls*: Option[bool]
        can_send_other_messages*: Option[bool]
        can_add_web_page_previews*: Option[bool]
        
    ChatPermissions* = object
        ## Describes actions that a non-administrator user is allowed to take in a chat.
        ## 
        ## Source: https://core.telegram.org/bots/api#chatpermissions
        
        can_send_messages*: Option[bool]
        can_send_media_messages*: Option[bool]
        can_send_polls*: Option[bool]
        can_send_other_messages*: Option[bool]
        can_add_web_page_previews*: Option[bool]
        can_change_info*: Option[bool]
        can_invite_users*: Option[bool]
        can_pin_messages*: Option[bool]
        
    BotCommand* = object
        ## This object represents a bot command.
        ## 
        ## Source: https://core.telegram.org/bots/api#botcommand
        
        command*: string
        description*: string
        
    ResponseParameters* = object
        ## Contains information about why a request was unsuccessful.
        ## 
        ## Source: https://core.telegram.org/bots/api#responseparameters
        
        migrate_to_chat_id*: Option[int64]
        retry_after*: Option[int32]
        
    InputMedia* = object
        ## This object represents the content of a media message to be sent. It should be one of
        ## - InputMediaAnimation
        ## - InputMediaDocument
        ## - InputMediaAudio
        ## - InputMediaPhoto
        ## - InputMediaVideo
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmedia
        
        
    InputMediaPhoto* = object
        ## Represents a photo to be sent.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmediaphoto
        
        `type`*: Option[string]
        media*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        
    InputMediaVideo* = object
        ## Represents a video to be sent.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmediavideo
        
        `type`*: Option[string]
        media*: string
        thumb*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        width*: Option[int32]
        height*: Option[int32]
        duration*: Option[int32]
        supports_streaming*: Option[bool]
        
    InputMediaAnimation* = object
        ## Represents an animation file (GIF or H.264/MPEG-4 AVC video without sound) to be sent.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmediaanimation
        
        `type`*: Option[string]
        media*: string
        thumb*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        width*: Option[int32]
        height*: Option[int32]
        duration*: Option[int32]
        
    InputMediaAudio* = object
        ## Represents an audio file to be treated as music to be sent.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmediaaudio
        
        `type`*: Option[string]
        media*: string
        thumb*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        duration*: Option[int32]
        performer*: Option[string]
        title*: Option[string]
        
    InputMediaDocument* = object
        ## Represents a general file to be sent.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmediadocument
        
        `type`*: Option[string]
        media*: string
        thumb*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        
    Sticker* = object
        ## This object represents a sticker.
        ## 
        ## Source: https://core.telegram.org/bots/api#sticker
        
        file_id*: string
        file_unique_id*: string
        width*: int32
        height*: int32
        is_animated*: bool
        thumb*: Option[PhotoSize]
        emoji*: Option[string]
        set_name*: Option[string]
        mask_position*: Option[MaskPosition]
        file_size*: Option[int32]
        
    StickerSet* = object
        ## This object represents a sticker set.
        ## 
        ## Source: https://core.telegram.org/bots/api#stickerset
        
        name*: string
        title*: string
        is_animated*: bool
        contains_masks*: bool
        stickers*: seq[Sticker]
        thumb*: Option[PhotoSize]
        
    MaskPosition* = object
        ## This object describes the position on faces where a mask should be placed by default.
        ## 
        ## Source: https://core.telegram.org/bots/api#maskposition
        
        point*: string
        x_shift*: float
        y_shift*: float
        scale*: float
        
    InlineQuery* = object
        ## This object represents an incoming inline query. When the user sends an empty query, your bot
        ## could return some default or trending results.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequery
        
        id*: string
        `from`*: User
        query*: string
        offset*: string
        location*: Option[Location]
        
    InlineQueryResult* = object
        ## This object represents one result of an inline query. Telegram clients currently support
        ## results of the following 20 types:
        ## - InlineQueryResultCachedAudio
        ## - InlineQueryResultCachedDocument
        ## - InlineQueryResultCachedGif
        ## - InlineQueryResultCachedMpeg4Gif
        ## - InlineQueryResultCachedPhoto
        ## - InlineQueryResultCachedSticker
        ## - InlineQueryResultCachedVideo
        ## - InlineQueryResultCachedVoice
        ## - InlineQueryResultArticle
        ## - InlineQueryResultAudio
        ## - InlineQueryResultContact
        ## - InlineQueryResultGame
        ## - InlineQueryResultDocument
        ## - InlineQueryResultGif
        ## - InlineQueryResultLocation
        ## - InlineQueryResultMpeg4Gif
        ## - InlineQueryResultPhoto
        ## - InlineQueryResultVenue
        ## - InlineQueryResultVideo
        ## - InlineQueryResultVoice
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresult
        
        
    InlineQueryResultArticle* = object
        ## Represents a link to an article or web page.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultarticle
        
        `type`*: Option[string]
        id*: string
        title*: string
        input_message_content*: InputMessageContent
        reply_markup*: Option[InlineKeyboardMarkup]
        url*: Option[string]
        hide_url*: Option[bool]
        description*: Option[string]
        thumb_url*: Option[string]
        thumb_width*: Option[int32]
        thumb_height*: Option[int32]
        
    InlineQueryResultPhoto* = object
        ## Represents a link to a photo. By default, this photo will be sent by the user with optional
        ## caption. Alternatively, you can use input_message_content to send a message with the specified
        ## content instead of the photo.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultphoto
        
        `type`*: Option[string]
        id*: string
        photo_url*: string
        thumb_url*: string
        photo_width*: Option[int32]
        photo_height*: Option[int32]
        title*: Option[string]
        description*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultGif* = object
        ## Represents a link to an animated GIF file. By default, this animated GIF file will be sent by
        ## the user with optional caption. Alternatively, you can use input_message_content to send a
        ## message with the specified content instead of the animation.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultgif
        
        `type`*: Option[string]
        id*: string
        gif_url*: string
        thumb_url*: string
        gif_width*: Option[int32]
        gif_height*: Option[int32]
        gif_duration*: Option[int32]
        thumb_mime_type*: Option[string]
        title*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultMpeg4Gif* = object
        ## Represents a link to a video animation (H.264/MPEG-4 AVC video without sound). By default,
        ## this animated MPEG-4 file will be sent by the user with optional caption. Alternatively, you
        ## can use input_message_content to send a message with the specified content instead of the
        ## animation.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultmpeg4gif
        
        `type`*: Option[string]
        id*: string
        mpeg4_url*: string
        thumb_url*: string
        mpeg4_width*: Option[int32]
        mpeg4_height*: Option[int32]
        mpeg4_duration*: Option[int32]
        thumb_mime_type*: Option[string]
        title*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultVideo* = object
        ## Represents a link to a page containing an embedded video player or a video file. By default,
        ## this video file will be sent by the user with an optional caption. Alternatively, you can use
        ## input_message_content to send a message with the specified content instead of the video.
        ## If an InlineQueryResultVideo message contains an embedded video (e.g., YouTube), you must
        ## replace its content using input_message_content.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultvideo
        
        `type`*: Option[string]
        id*: string
        video_url*: string
        mime_type*: string
        thumb_url*: string
        title*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        video_width*: Option[int32]
        video_height*: Option[int32]
        video_duration*: Option[int32]
        description*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultAudio* = object
        ## Represents a link to an MP3 audio file. By default, this audio file will be sent by the user.
        ## Alternatively, you can use input_message_content to send a message with the specified content
        ## instead of the audio.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultaudio
        
        `type`*: Option[string]
        id*: string
        audio_url*: string
        title*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        performer*: Option[string]
        audio_duration*: Option[int32]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultVoice* = object
        ## Represents a link to a voice recording in an .OGG container encoded with OPUS. By default,
        ## this voice recording will be sent by the user. Alternatively, you can use
        ## input_message_content to send a message with the specified content instead of the the voice
        ## message.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultvoice
        
        `type`*: Option[string]
        id*: string
        voice_url*: string
        title*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        voice_duration*: Option[int32]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultDocument* = object
        ## Represents a link to a file. By default, this file will be sent by the user with an optional
        ## caption. Alternatively, you can use input_message_content to send a message with the specified
        ## content instead of the file. Currently, only .PDF and .ZIP files can be sent using this
        ## method.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultdocument
        
        `type`*: Option[string]
        id*: string
        title*: string
        document_url*: string
        mime_type*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        description*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        thumb_url*: Option[string]
        thumb_width*: Option[int32]
        thumb_height*: Option[int32]
        
    InlineQueryResultLocation* = object
        ## Represents a location on a map. By default, the location will be sent by the user.
        ## Alternatively, you can use input_message_content to send a message with the specified content
        ## instead of the location.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultlocation
        
        `type`*: Option[string]
        id*: string
        latitude*: float
        longitude*: float
        title*: string
        live_period*: Option[int32]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        thumb_url*: Option[string]
        thumb_width*: Option[int32]
        thumb_height*: Option[int32]
        
    InlineQueryResultVenue* = object
        ## Represents a venue. By default, the venue will be sent by the user. Alternatively, you can use
        ## input_message_content to send a message with the specified content instead of the venue.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultvenue
        
        `type`*: Option[string]
        id*: string
        latitude*: float
        longitude*: float
        title*: string
        address*: string
        foursquare_id*: Option[string]
        foursquare_type*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        thumb_url*: Option[string]
        thumb_width*: Option[int32]
        thumb_height*: Option[int32]
        
    InlineQueryResultContact* = object
        ## Represents a contact with a phone number. By default, this contact will be sent by the user.
        ## Alternatively, you can use input_message_content to send a message with the specified content
        ## instead of the contact.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcontact
        
        `type`*: Option[string]
        id*: string
        phone_number*: string
        first_name*: string
        last_name*: Option[string]
        vcard*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        thumb_url*: Option[string]
        thumb_width*: Option[int32]
        thumb_height*: Option[int32]
        
    InlineQueryResultGame* = object
        ## Represents a Game.
        ## Note: This will only work in Telegram versions released after October 1, 2016. Older clients
        ## will not display any inline results if a game result is among them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultgame
        
        `type`*: Option[string]
        id*: string
        game_short_name*: string
        reply_markup*: Option[InlineKeyboardMarkup]
        
    InlineQueryResultCachedPhoto* = object
        ## Represents a link to a photo stored on the Telegram servers. By default, this photo will be
        ## sent by the user with an optional caption. Alternatively, you can use input_message_content to
        ## send a message with the specified content instead of the photo.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedphoto
        
        `type`*: Option[string]
        id*: string
        photo_file_id*: string
        title*: Option[string]
        description*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedGif* = object
        ## Represents a link to an animated GIF file stored on the Telegram servers. By default, this
        ## animated GIF file will be sent by the user with an optional caption. Alternatively, you can
        ## use input_message_content to send a message with specified content instead of the animation.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedgif
        
        `type`*: Option[string]
        id*: string
        gif_file_id*: string
        title*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedMpeg4Gif* = object
        ## Represents a link to a video animation (H.264/MPEG-4 AVC video without sound) stored on the
        ## Telegram servers. By default, this animated MPEG-4 file will be sent by the user with an
        ## optional caption. Alternatively, you can use input_message_content to send a message with the
        ## specified content instead of the animation.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedmpeg4gif
        
        `type`*: Option[string]
        id*: string
        mpeg4_file_id*: string
        title*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedSticker* = object
        ## Represents a link to a sticker stored on the Telegram servers. By default, this sticker will
        ## be sent by the user. Alternatively, you can use input_message_content to send a message with
        ## the specified content instead of the sticker.
        ## Note: This will only work in Telegram versions released after 9 April, 2016 for static
        ## stickers and after 06 July, 2019 for animated stickers. Older clients will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedsticker
        
        `type`*: Option[string]
        id*: string
        sticker_file_id*: string
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedDocument* = object
        ## Represents a link to a file stored on the Telegram servers. By default, this file will be sent
        ## by the user with an optional caption. Alternatively, you can use input_message_content to send
        ## a message with the specified content instead of the file.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcacheddocument
        
        `type`*: Option[string]
        id*: string
        title*: string
        document_file_id*: string
        description*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedVideo* = object
        ## Represents a link to a video file stored on the Telegram servers. By default, this video file
        ## will be sent by the user with an optional caption. Alternatively, you can use
        ## input_message_content to send a message with the specified content instead of the video.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedvideo
        
        `type`*: Option[string]
        id*: string
        video_file_id*: string
        title*: string
        description*: Option[string]
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedVoice* = object
        ## Represents a link to a voice message stored on the Telegram servers. By default, this voice
        ## message will be sent by the user. Alternatively, you can use input_message_content to send a
        ## message with the specified content instead of the voice message.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedvoice
        
        `type`*: Option[string]
        id*: string
        voice_file_id*: string
        title*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InlineQueryResultCachedAudio* = object
        ## Represents a link to an MP3 audio file stored on the Telegram servers. By default, this audio
        ## file will be sent by the user. Alternatively, you can use input_message_content to send a
        ## message with the specified content instead of the audio.
        ## Note: This will only work in Telegram versions released after 9 April, 2016. Older clients
        ## will ignore them.
        ## 
        ## Source: https://core.telegram.org/bots/api#inlinequeryresultcachedaudio
        
        `type`*: Option[string]
        id*: string
        audio_file_id*: string
        caption*: Option[string]
        parse_mode*: Option[string]
        reply_markup*: Option[InlineKeyboardMarkup]
        input_message_content*: Option[InputMessageContent]
        
    InputMessageContent* = object
        ## This object represents the content of a message to be sent as a result of an inline query.
        ## Telegram clients currently support the following 4 types:
        ## - InputTextMessageContent
        ## - InputLocationMessageContent
        ## - InputVenueMessageContent
        ## - InputContactMessageContent
        ## 
        ## Source: https://core.telegram.org/bots/api#inputmessagecontent
        
        
    InputTextMessageContent* = object
        ## Represents the content of a text message to be sent as the result of an inline query.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputtextmessagecontent
        
        message_text*: string
        parse_mode*: Option[string]
        disable_web_page_preview*: Option[bool]
        
    InputLocationMessageContent* = object
        ## Represents the content of a location message to be sent as the result of an inline query.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputlocationmessagecontent
        
        latitude*: float
        longitude*: float
        live_period*: Option[int32]
        
    InputVenueMessageContent* = object
        ## Represents the content of a venue message to be sent as the result of an inline query.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputvenuemessagecontent
        
        latitude*: float
        longitude*: float
        title*: string
        address*: string
        foursquare_id*: Option[string]
        foursquare_type*: Option[string]
        
    InputContactMessageContent* = object
        ## Represents the content of a contact message to be sent as the result of an inline query.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputcontactmessagecontent
        
        phone_number*: string
        first_name*: string
        last_name*: Option[string]
        vcard*: Option[string]
        
    ChosenInlineResult* = object
        ## Represents a result of an inline query that was chosen by the user and sent to their chat
        ## partner.
        ## Note: It is necessary to enable inline feedback via @Botfather in order to receive these
        ## objects in updates.
        ## 
        ## Source: https://core.telegram.org/bots/api#choseninlineresult
        
        result_id*: string
        `from`*: User
        query*: string
        location*: Option[Location]
        inline_message_id*: Option[string]
        
    LabeledPrice* = object
        ## This object represents a portion of the price for goods or services.
        ## 
        ## Source: https://core.telegram.org/bots/api#labeledprice
        
        label*: string
        amount*: int32
        
    Invoice* = object
        ## This object contains basic information about an invoice.
        ## 
        ## Source: https://core.telegram.org/bots/api#invoice
        
        title*: string
        description*: string
        start_parameter*: string
        currency*: string
        total_amount*: int32
        
    ShippingAddress* = object
        ## This object represents a shipping address.
        ## 
        ## Source: https://core.telegram.org/bots/api#shippingaddress
        
        country_code*: string
        state*: string
        city*: string
        street_line1*: string
        street_line2*: string
        post_code*: string
        
    OrderInfo* = object
        ## This object represents information about an order.
        ## 
        ## Source: https://core.telegram.org/bots/api#orderinfo
        
        name*: Option[string]
        phone_number*: Option[string]
        email*: Option[string]
        shipping_address*: Option[ShippingAddress]
        
    ShippingOption* = object
        ## This object represents one shipping option.
        ## 
        ## Source: https://core.telegram.org/bots/api#shippingoption
        
        id*: string
        title*: string
        prices*: seq[LabeledPrice]
        
    SuccessfulPayment* = object
        ## This object contains basic information about a successful payment.
        ## 
        ## Source: https://core.telegram.org/bots/api#successfulpayment
        
        currency*: string
        total_amount*: int32
        invoice_payload*: string
        telegram_payment_charge_id*: string
        provider_payment_charge_id*: string
        shipping_option_id*: Option[string]
        order_info*: Option[OrderInfo]
        
    ShippingQuery* = object
        ## This object contains information about an incoming shipping query.
        ## 
        ## Source: https://core.telegram.org/bots/api#shippingquery
        
        id*: string
        `from`*: User
        invoice_payload*: string
        shipping_address*: ShippingAddress
        
    PreCheckoutQuery* = object
        ## This object contains information about an incoming pre-checkout query.
        ## 
        ## Source: https://core.telegram.org/bots/api#precheckoutquery
        
        id*: string
        `from`*: User
        currency*: string
        total_amount*: int32
        invoice_payload*: string
        shipping_option_id*: Option[string]
        order_info*: Option[OrderInfo]
        
    PassportData* = object
        ## Contains information about Telegram Passport data shared with the bot by the user.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportdata
        
        data*: seq[EncryptedPassportElement]
        credentials*: EncryptedCredentials
        
    PassportFile* = object
        ## This object represents a file uploaded to Telegram Passport. Currently all Telegram Passport
        ## files are in JPEG format when decrypted and don't exceed 10MB.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportfile
        
        file_id*: string
        file_unique_id*: string
        file_size*: int32
        file_date*: int32
        
    EncryptedPassportElement* = object
        ## Contains information about documents or other Telegram Passport elements shared with the bot
        ## by the user.
        ## 
        ## Source: https://core.telegram.org/bots/api#encryptedpassportelement
        
        `type`*: string
        hash*: string
        data*: Option[string]
        phone_number*: Option[string]
        email*: Option[string]
        files*: Option[seq[PassportFile]]
        front_side*: Option[PassportFile]
        reverse_side*: Option[PassportFile]
        selfie*: Option[PassportFile]
        translation*: Option[seq[PassportFile]]
        
    EncryptedCredentials* = object
        ## Contains data required for decrypting and authenticating EncryptedPassportElement. See the
        ## Telegram Passport Documentation for a complete description of the data decryption and
        ## authentication processes.
        ## 
        ## Source: https://core.telegram.org/bots/api#encryptedcredentials
        
        data*: string
        hash*: string
        secret*: string
        
    PassportElementError* = object
        ## This object represents an error in the Telegram Passport element which was submitted that
        ## should be resolved by the user. It should be one of:
        ## - PassportElementErrorDataField
        ## - PassportElementErrorFrontSide
        ## - PassportElementErrorReverseSide
        ## - PassportElementErrorSelfie
        ## - PassportElementErrorFile
        ## - PassportElementErrorFiles
        ## - PassportElementErrorTranslationFile
        ## - PassportElementErrorTranslationFiles
        ## - PassportElementErrorUnspecified
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerror
        
        
    PassportElementErrorDataField* = object
        ## Represents an issue in one of the data fields that was provided by the user. The error is
        ## considered resolved when the field's value changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrordatafield
        
        source*: Option[string]
        `type`*: string
        field_name*: string
        data_hash*: string
        message*: string
        
    PassportElementErrorFrontSide* = object
        ## Represents an issue with the front side of a document. The error is considered resolved when
        ## the file with the front side of the document changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrorfrontside
        
        source*: Option[string]
        `type`*: string
        file_hash*: string
        message*: string
        
    PassportElementErrorReverseSide* = object
        ## Represents an issue with the reverse side of a document. The error is considered resolved when
        ## the file with reverse side of the document changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrorreverseside
        
        source*: Option[string]
        `type`*: string
        file_hash*: string
        message*: string
        
    PassportElementErrorSelfie* = object
        ## Represents an issue with the selfie with a document. The error is considered resolved when the
        ## file with the selfie changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrorselfie
        
        source*: Option[string]
        `type`*: string
        file_hash*: string
        message*: string
        
    PassportElementErrorFile* = object
        ## Represents an issue with a document scan. The error is considered resolved when the file with
        ## the document scan changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrorfile
        
        source*: Option[string]
        `type`*: string
        file_hash*: string
        message*: string
        
    PassportElementErrorFiles* = object
        ## Represents an issue with a list of scans. The error is considered resolved when the list of
        ## files containing the scans changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrorfiles
        
        source*: Option[string]
        `type`*: string
        file_hashes*: seq[string]
        message*: string
        
    PassportElementErrorTranslationFile* = object
        ## Represents an issue with one of the files that constitute the translation of a document. The
        ## error is considered resolved when the file changes.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrortranslationfile
        
        source*: Option[string]
        `type`*: string
        file_hash*: string
        message*: string
        
    PassportElementErrorTranslationFiles* = object
        ## Represents an issue with the translated version of a document. The error is considered
        ## resolved when a file with the document translation change.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrortranslationfiles
        
        source*: Option[string]
        `type`*: string
        file_hashes*: seq[string]
        message*: string
        
    PassportElementErrorUnspecified* = object
        ## Represents an issue in an unspecified place. The error is considered resolved when new data is
        ## added.
        ## 
        ## Source: https://core.telegram.org/bots/api#passportelementerrorunspecified
        
        source*: Option[string]
        `type`*: string
        element_hash*: string
        message*: string
        
    Game* = object
        ## This object represents a game. Use BotFather to create and edit games, their short names will
        ## act as unique identifiers.
        ## 
        ## Source: https://core.telegram.org/bots/api#game
        
        title*: string
        description*: string
        photo*: seq[PhotoSize]
        text*: Option[string]
        text_entities*: Option[seq[MessageEntity]]
        animation*: Option[Animation]
        
    CallbackGame* = object
        ## A placeholder, currently holds no information. Use BotFather to set up your game.
        ## 
        ## Source: https://core.telegram.org/bots/api#callbackgame
        
        
    GameHighScore* = object
        ## This object represents one row of the high scores table for a game.
        ## And that's about all we've got for now.
        ## If you've got any questions, please check out our Bot FAQ
        ## 
        ## Source: https://core.telegram.org/bots/api#gamehighscore
        
        position*: int32
        user*: User
        score*: int32

    InputFile* = FSInputFile
        ## This object represents the contents of a file to be uploaded. 
        ## Must be posted using multipart/form-data in the usual way that files are uploaded via the browser.
        ## 
        ## Source: https://core.telegram.org/bots/api#inputfile

    FSInputFile* = object
        ## Upload file from disk
        content*: string

    KeyboardMarkup* = InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply
