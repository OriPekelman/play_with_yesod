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
    articles <- runDB $ selectList [] [Desc PostTitle]
    -- We'll need the two "objects": articleWidget and enctype
    -- to construct the form (see templates/articles.hamlet).
    (articleWidget, enctype) <- generateFormPost entryForm
    defaultLayout $ do
        $(widgetFile "posts")