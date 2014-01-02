module Web.Herringbone.Preprocessor.Fay where

import Data.Char
import Data.ByteString (ByteString)
import qualified Data.ByteString as B
import System.IO
import System.IO.Temp
import qualified Fay
import Web.Herringbone

compile :: Fay.CompileConfig -> ByteString -> IO (Either CompileError ByteString)
compile config inputData = do
    withSystemTempFile "herringbone-fay.hs" $ \path h -> do
        B.hPutStr h inputData
        hClose h

        result <- Fay.compileFile config path
        either (return . Left . toBS . Fay.showCompileError)
               (return . Right . toBS . fst)
               result
    where
        toBS = B.pack . map (fromIntegral . ord)

fay :: Fay.CompileConfig -> PP
fay config = PP
    { ppExtension = "fay"
    , ppAction    = compile config
    }
