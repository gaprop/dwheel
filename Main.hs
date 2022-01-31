module Main where
import Parser
import ParserAnswer
import Text.ParserCombinators.Parsec
import System.Environment
import System.IO
import System.Console.ANSI

main = do
  args <- getArgs
  withFile (args !! 0) ReadMode (\handle0 -> do
    withFile (args !! 1) ReadMode (\handle1 -> do
      guesses <- hGetContents handle0
      answers <- hGetContents handle1
      let guesses' = parse parseResult "Guesses" guesses
          answers' = parse parseAnswers "Answers" answers
      print "Hello"
       -- in case (guesses', answers') of
        -- (Right pGuesses, Right pAnswers) -> print $ run pGuesses pAnswers
      )
    )

run :: [(Declension, [Guess])] -> [[Answer]] -> String
run guesses answers = map (\(Left (wrong, right), Right (s) -> "Hello") compared
  where compared = compareParsed guesses answers
   

compareParsed :: [(Declension, [Guess])] -> [[Answer]] -> [Either (String, String) String]
compareParsed guesses answers = flatten . map (map compareParsed') . wrap $ ((map snd guesses), answers)
  where 
    flatten = concat
    compareParsed' :: (Guess, Answer) -> Either (String, String) String
    compareParsed' ((Guess x), (Answer y)) = if x == y 
                                               then Right x
                                               else Left (x, y)

    wrap :: ([[a]], [[b]]) -> [[(a, b)]]
    wrap (x, y) = map (\(x, y) -> zip x y) $ zip x y

