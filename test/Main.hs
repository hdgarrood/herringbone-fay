module Main where

import Data.Default
import Network.Wai
import Network.Wai.Handler.Warp
import Web.Herringbone
import Web.Herringbone.Preprocessor.Fay

hb :: Herringbone
hb = herringbone
    ( addSourceDir "test/resources/assets"
    . setDestDir   "test/resources/compiled_assets"
    . addPreprocessors [fay def]
    )

app :: Application
app = toApplication hb

main :: IO ()
main = run 3000 app
