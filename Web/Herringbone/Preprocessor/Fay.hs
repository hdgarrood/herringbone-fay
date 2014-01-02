module Web.Herringbone.Preprocessor.Fay where

import Data.ByteString (ByteString)
import qualified Data.ByteString as B
import System.IO.Temp
import Fay
import Web.Herringbone

compile :: CompileConfig -> ByteString -> IO (Either CompileError ByteString)
compile config inputData = do
    withSystemTempFile "herringbone-fay.hs" $ \(path, h) -> do
        B.hPutStr h inputData
        hClose h

        result <- compileFile config path
        either (return . Left . stringToByteString . showCompileError)
               (return . Right . stringToByteString)
               result
    where
        toBS = B.pack . map (fromIntegral . ord)

fay :: CompileConfig -> PP
fay config = PP
    { ppExtension = "fay"
    , ppAction    = compile config
    }
