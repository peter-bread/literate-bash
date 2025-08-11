{-# LANGUAGE ViewPatterns #-}

module Main where

import Data.Char (toUpper)
import Data.List (stripPrefix)

type CodeLines = [String]

data ProcessingMode = Code | Normal
  deriving (Eq, Show)

main :: IO ()
main = do
  -- TODO: cmdline arg + validation
  content <- readFile "example.lsh.md"
  let contentLines = lines content
  let codeLines = getCodeLines [] Normal contentLines
  -- TODO: run the code
  putStrLn (unlines codeLines)

-- >>> getCodeLines [] Normal ["hello", "```bash", "foo", "bar", "```", "bye", "```bash", "baz", "```", "end"]
-- ["foo","bar","","baz",""]
getCodeLines :: CodeLines -> ProcessingMode -> [String] -> CodeLines
getCodeLines acc _ [] = reverse acc
getCodeLines acc Normal (x : xs) = case x of
  (stripPrefix "```bash" -> Just _) -> getCodeLines acc Code xs
  _ -> getCodeLines acc Normal xs
getCodeLines acc Code (x : xs) = case x of
  (stripPrefix "```" -> Just _) -> getCodeLines ("" : acc) Normal xs
  _ -> getCodeLines (x : acc) Code xs
