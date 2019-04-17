--------------------------------------------------
-- Extensions ------------------------------------
--------------------------------------------------

{-# LANGUAGE BlockArguments        #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ApplicativeDo         #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns        #-}

--------------------------------------------------

{- |

-}

module Program.MTG.JSON.IO where

--------------------------------------------------
-- Imports (Internal) ----------------------------
--------------------------------------------------

import Program.MTG.JSON.Types
import Program.MTG.JSON.Paths
import Program.MTG.JSON.Constants
import Program.MTG.JSON.Prelude

--------------------------------------------------
-- Imports (External) ----------------------------
--------------------------------------------------

import qualified "zlib" Codec.Compression.GZip     as GZIP    -- GZIP format 
import qualified "zlib" Codec.Compression.Zlib     as ZLIB    -- ZLIB format 
import qualified "zlib" Codec.Compression.Zlib.Raw as DEFLATE -- DEFLATE format 
import qualified "zlib" Codec.Compression.Zlib.Raw as Z

--------------------------------------------------

import qualified "zip-archive" Codec.Archive.Zip as ZIP

--------------------------------------------------

import qualified "http-types"      Network.HTTP.Types.Status as HTTP
import qualified "http-client"     Network.HTTP.Client       as HTTP
import qualified "http-client-tls" Network.HTTP.Client.TLS   as HTTPS

--------------------------------------------------

import qualified "http-conduit" Network.HTTP.Simple as HTTP.Conduit
import           "http-conduit" Network.HTTP.Simple ( )

--------------------------------------------------

import qualified "conduit" Conduit as Conduit
import           "conduit" Conduit ( ConduitM )

--------------------------------------------------

import qualified "resourcet" Control.Monad.Trans.Resource as Resource
import           "resourcet" Control.Monad.Trans.Resource ( ResourceT )

--------------------------------------------------

import qualified "formatting" Formatting as Format
import           "formatting" Formatting ( (%) )

--------------------------------------------------
--- Imports --------------------------------------
--------------------------------------------------

import qualified "directory" System.Directory as Directory

--------------------------------------------------

import qualified "bytestring" Data.ByteString            as Strict
import qualified "bytestring" Data.ByteString.Lazy       as Lazy
import qualified "bytestring" Data.ByteString.Lazy.Char8 as ASCII

import           "bytestring" Data.ByteString ( ByteString )

--------------------------------------------------

import qualified "base" System.IO as IO

import qualified "base" Prelude

--------------------------------------------------
-- IO --------------------------------------------
--------------------------------------------------

{- | Any @mtg-json@ invocation executes @runCommand@.

== CLI

@
$ mtg-json ...
@

-}

runCommand :: Command -> IO ()
runCommand Command{ subcommand, options } = go subcommand
  where

  go :: Subcommand -> IO ()
  go = \case

      FetchJSON srcdst -> do
        fetchMTG options srcdst

      PrintVersion -> do
        printVersion options

      PrintLicense -> do
        printLicense options

--------------------------------------------------

{- | 

== CLI

@
$ mtg-json fetch --input ... --output ... (all | vintage | ...)
@

-}

fetchMTG :: Options -> SrcDst -> IO ()
fetchMTG Options{..} SrcDst{src,dst} = do

  putStdErr sSrc

  bytes <- inputSrc

  putStdErr sDst

  outputDst bytes

  where

  ------------------------------

  sSrc :: String
  sSrc = runFormat ("\nFetching from: " % Format.string % " ...\n") s
      where
      s = prettySrc src

  sDst :: String
  sDst = runFormat ("\nSaving to:     " % Format.string % " ...\n") s
      where
      s = prettyDst dst

  ------------------------------

  inputSrc :: IO LazyBytes
  inputSrc = case dryrun of

    DryRun  -> return ""
    TrueRun -> readSrc src

  ------------------------------

  outputDst :: (MTGHS String) -> IO ()
  outputDst bytes = case dryrun of

    DryRun  -> return ""
    TrueRun -> case dst of

      DstStdout -> do

          printDst mtg_hs

      DstFile fp -> do

          writeDst fp mtg_hs

  ------------------------------

  printDst :: (MTGHS String) -> IO ()
  printDst (MTGHS mtg) = putStdOut mtg

  ------------------------------

  writeDst :: FilePath -> (MTGHS String) -> IO ()
  writeDst fp (MTGHS mtg) = case forcefulness of

      RespectExisting -> do

        let e = runFormat ("\n[Error] Filepath {{{ " % Format.string % " }}} already exists. Rerun <<< " % Format.string % " >>> with the <<< --force >>> option to overwrite.\n") fp programExecutable -- TODO -- prompt user to confirm.

        bExists <- Directory.doesPathExist fp
        if   bExists
        then putStdErr e
        else IO.writeFile fp mtg

      OverwriteExisting -> do

        IO.writeFile fp mtg

  ------------------------------

{-# INLINEABLE fetchMTG #-}

--------------------------------------------------

{- | 

== CLI

@
$ mtg-json print version
@

-}

printVersion :: Options -> IO ()
printVersion Options{..} = do

  go verbose

  where

  go = \case

    Quiet   -> printVersionConcise
    Concise -> printVersionConcise

    Verbose -> printVersionVerbose
    Loud    -> printVersionVerbose

  printVersionConcise = do

    putStrLn $ programVersionBranch

  printVersionVerbose = do

    let versionLine = concat [ programName, ", version ", programVersion ]

    putStrLn $ versionLine

--  let versionString = versionStringBranch ++ versionStringTags

{-# INLINEABLE printVersion #-}

--------------------------------------------------

{- | 

== CLI

@
$ mtg-json print license
@

-}

printLicense :: Options -> IO ()
printLicense Options{..} = do

  go verbose

  where

  go = \case

    Quiet   -> printLicenseConcise
    Concise -> printLicenseConcise

    Verbose -> printLicenseVerbose
    Loud    -> printLicenseVerbose

  printLicenseConcise = do

    putStrLn $ programLicenseIdentifier

  printLicenseVerbose = do

    printLicenseConcise
    putStrLn ""

    putStrLn $ programLicenseContents

{-# INLINEABLE printLicense #-}

--------------------------------------------------
-- Functions -------------------------------------
--------------------------------------------------

{- | Download and decompress a @JSON@ file.

== Exceptions

May throw:

* `HTTP.HttpException`
* ``

-}

fetch :: forall a. FetchConfig a -> IO a
fetch config = do

  let settings = HTTPS.tlsManagerSettings

  manager <- HTTPS.newTlsManagerWith settings

  fetchWith manager config

{-# INLINEABLE fetch #-}

--------------------------------------------------

{- | (See `fetch`.) -}

fetchWith :: forall a. HTTP.Manager -> FetchConfig a -> IO a
fetchWith manager config = go config
  where

  go :: FetchConfig a -> IO a
  go = \case

    FetchMtgJsonGz uri -> fetchMtgJsonGz uri

  fetchMtgJsonGz :: URI -> IO (MTGJSON a)
  fetchMtgJsonGz uri = do

    request  <- HTTP.parseUrlThrow uri
    response <- HTTP.httpLbs request manager

    let body   = (response & HTTP.responseBody)
    let status = (response & HTTP.responseStatus)

    return body

{-# INLINEABLE fetchWith #-}

--------------------------------------------------

{- | Read bytes “lazily” (`LazyBytes`) from a given source (`Src`).

-}

readSrc :: Src -> IO LazyBytes
readSrc = \case

  SrcBytes  bs -> return bs
  SrcBytes' bs -> return (Lazy.fromChunks [bs])

  SrcStdin   -> readSrcStdin
  SrcFile fp -> Lazy.readFile fp
  SrcUri uri -> do

    fp <- newTemporaryFilePath uri

    download Nothing uri fp
    Lazy.readFile fp

--------------------------------------------------

{- | Read bytes “lazily” (`LazyBytes`) from @stdin@ (`IO.stdin`).

-}

readSrcStdin :: IO LazyBytes
readSrcStdin = do
  IO.hSetBinaryMode IO.stdin True
  Lazy.hGetContents IO.stdin

--------------------------------------------------

{- | Copy the given source (`Src`) to a file (`FilePath`).

-}

copySrc :: FilePath -> Src -> IO LazyBytes
copySrc fpDst = \case

  SrcBytes  bsSrc -> Lazy.writeFile fpDst bsSrc
  SrcBytes' bsSrc -> Strict.writeFile fpDst bsSrc

  SrcStdin      -> readSrcStdin >>= Lazy.writeFile fpDst
  SrcFile fpSrc -> Directory.copyFile fpSrc fpDst
  SrcUri uriSrc -> download Nothing uriSrc fpDst

--------------------------------------------------
-- Utilities -------------------------------------
--------------------------------------------------

mtgjson2mtghs :: MTGJSON a -> MTGHS a
mtgjson2mtghs (MTGJSON x) = (MTGHS x) -- TODO

--------------------------------------------------

{- | Download a file.

@download method uri fp@ downloads URI @uri@ to FilePath @fp@ (with optional request method @method@).

The file contents being downloaded may be larger than available memory. @uri@ is streamed into @fp@.

== Examples

@
>> download (Just "GET") "https://mtgjson.com/json/Vintage.json.gz" "/tmp/Vintage.json.gz"
@

-}

download :: Maybe String -> URI -> FilePath -> IO ()
download method uri fp = do

  request <- HTTP.parseRequest uri'

  Resource.runResourceT (HTTP.Conduit.httpSink request consume)

  where

  method' = method & maybe "" (++ " ")
  uri'    = method' <> uri

  consume :: HTTP.Response () -> ConduitM ByteString Void (ResourceT IO) ()
  consume response = do

    Conduit.sinkFileCautious fp

--------------------------------------------------
-- Notes -----------------------------------------
--------------------------------------------------

-- type Sink i = ConduitM i Void

-- sinkFile :: MonadResource m => FilePath -> ConduitT ByteString o m ()
-- sinkFile :: FilePath -> ConduitT ByteString o IO ()
-- sinkFile :: FilePath -> ConduitT ByteString Void IO ()
-- sinkFile :: FilePath -> Sink ByteString IO ()

-- httpSink :: MonadUnliftIO m => Request -> (Response () -> ConduitM ByteString Void m a) -> m a

-- runResourceT :: MonadUnliftIO m => ResourceT m a -> m a

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------