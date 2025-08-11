{-# LANGUAGE ViewPatterns #-}

module Main where

import Data.Char (toUpper)
import Data.List (stripPrefix)

main :: IO ()
main = do
  -- TODO: cmdline arg + validation
  content <- readFile "example.lsh.md"
  let contentLines = lines content
  let codeLines = getCodeLines [] False contentLines
  -- TODO: run the code
  putStrLn (unlines codeLines)

-- >>> getCodeLines [] False ["hello", "```bash", "foo", "bar", "```", "bye", "```bash", "baz", "```", "end"]
-- ["foo","bar","baz"]
getCodeLines :: [String] -> Bool -> [String] -> [String]
getCodeLines acc _ [] = acc
getCodeLines acc False (x : xs) = case x of
  (stripPrefix "```bash" -> Just _) -> getCodeLines acc True xs
  _ -> getCodeLines acc False xs
getCodeLines acc True (x : xs) = case x of
  (stripPrefix "```" -> Just _) -> getCodeLines (acc ++ [""]) False xs
  _ -> getCodeLines (acc ++ [x]) True xs
