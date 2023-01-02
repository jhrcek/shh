{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Main where

import Control.Monad
import Shh
import Data.Monoid
import Data.Char
import Data.List
import Control.Concurrent.Async

-- Load everything...
-- $(loadEnv SearchPath)

-- OR --

-- We could also be a little more explicit about it.
$(load Absolute ["sleep", "echo", "cat", "tr"])

main :: IO ()
main = do
    -- Crash the program if we are missing any executables.
    [] <- missingExecutables
    concurrently_
        ((sleep 1 >> echo "Hello" >> sleep 2) |> cat)
        (echo "A" >> sleep 1 >> echo "bc" |> tr "-d" "c")
