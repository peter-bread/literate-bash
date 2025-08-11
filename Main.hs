{-# LANGUAGE ViewPatterns #-}

module Main where

import Data.Char (toUpper)
import Data.List (stripPrefix)

type Code = String
type Line = String

type Lines = [String]
type CodeLines = [Code]

data ProcessingMode = Code | Normal
  deriving (Eq, Show)

-- TODO: cmdline arg + validation
-- TODO: run the code

main :: IO ()
main = do
  code <- getCodeFromFile "example.lsh.md"
  putStrLn code

-- TODO: https://github.com/peter-bread/literate-bash/issues/1
getCodeFromFile :: FilePath -> IO Code
getCodeFromFile = fmap unlines . getCodeLinesFromFile

getCodeLinesFromFile :: FilePath -> IO CodeLines
getCodeLinesFromFile filepath = do
  content <- readFile filepath
  let contentLines = lines content
  return (getCodeLinesFromLines contentLines)

-- >>> getCodeLinesFromLines ["hello", "```bash", "foo", "bar", "```", "bye", "```bash", "baz", "```", "end"]
-- ["foo","bar","","baz",""]
getCodeLinesFromLines :: Lines -> CodeLines
getCodeLinesFromLines = go [] Normal
 where
  go :: CodeLines -> ProcessingMode -> Lines -> CodeLines
  go acc _ [] = reverse acc
  go acc Normal (x : xs) = case x of
    (stripPrefix "```bash" -> Just _) -> go acc Code xs
    _ -> go acc Normal xs
  go acc Code (x : xs) = case x of
    (stripPrefix "```" -> Just _) -> go ("" : acc) Normal xs
    _ -> go (x : acc) Code xs

-- TODO: use these to match entire line rather than just prefix?
-- "```bash" -> go acc Code xs
-- "```" -> go ("" : acc) Normal xs
