module Web.Herringbone.Preprocessor.Fay where

import Data.Char
import Data.ByteString (ByteString)
import qualified Data.ByteString as B
import System.IO
import System.IO.Temp
import qualified Fay
import qualified Fay.Compiler.Config as Fay
import Web.Herringbone

compile :: Fay.CompileConfig -> ByteString -> IO (Either CompileError ByteString)
compile config inputData = do
    withSystemTempDirectory "herringbone-fay" $ \tmpDir -> do
        let path = tmpDir ++ "/HelloWorld.hs"
        withFile path WriteMode $ \h -> do
            B.hPutStr h inputData
            hClose h

        let config' = Fay.addConfigDirectoryIncludePaths [tmpDir] config
        result <- Fay.compileFile config' path
        either (return . Left . toBS . wrapWithPre . Fay.showCompileError)
               (return . Right . toBS . fst)
               result
    where
        toBS = B.pack . map (fromIntegral . ord)
        wrapWithPre str = "<pre>" ++ str ++ "</pre>"

fay :: Fay.CompileConfig -> PP
fay config = PP
    { ppExtension = "fay"
    , ppAction    = compile config
    }
