module Handler.Blog
    ( getBlogR
    , postBlogR
    , getPostR
    )
where

import Import
import Data.Monoid
import Data.Time

-- to use Html into forms
import Yesod.Form.Nic (YesodNic, nicHtmlField)
instance YesodNic App
-- The view for the Form
entryForm :: Form Article
entryForm = renderDivs $ Article
    <$> areq   textField "Title" Nothing
    <*> areq   nicHtmlField "Content" Nothing
    
-- The view showing the list of posts
getBlogR :: Handler RepHtml
getBlogR = do
    -- Get the list of articles inside the database.
    posts <- runDB $ selectList [] [Desc PostTitle]
    -- We'll need the two "objects": articleWidget and enctype
    -- to construct the form (see templates/posts.hamlet).
    (postWidget, enctype) <- generateFormPost entryForm
    defaultLayout $ do
        $(widgetFile "posts")
-- we continue Handler/Blog.hs for posting
postBlogR :: Handler RepHtml
postBlogR = do
    ((res,postWidget),enctype) <- runFormPost entryForm
    case res of 
         FormSuccess post -> do 
            postId <- runDB $ insert post
            setMessage $ toHtml $ (postTitle post) <> " created"
            redirect $ PostR postId 
         _ -> defaultLayout $ do
                setTitle "Please correct your entry form"
                $(widgetFile "postAddError")         
getPostR :: PostId -> Handler RepHtml
getPostR postId = do
    post <- runDB $ get404 postId
    defaultLayout $ do
        setTitle $ toHtml $ postTitle post
        $(widgetFile "post")