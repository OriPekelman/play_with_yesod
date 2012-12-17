{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home
    ( getBlogR
    , postBlogR
    , getPostR
    )
where
import Import
import Data.Time (UTCTime)
-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler RepHtml
getHomeR = do
    -- Get the list of articles inside the database.
    posts <- runDB $ selectList [] [Desc PostTitle]
    -- We'll need the two "objects": articleWidget and enctype
    -- to construct the form (see templates/posts.hamlet).
    (postWidget, enctype) <- generateFormPost entryForm
    defaultLayout $ do
        $(widgetFile "posts")
