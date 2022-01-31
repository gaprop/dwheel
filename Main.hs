module Main where
import Parser
import ParserAnswer
import Text.ParserCombinators.Parsec
import System.Environment
import System.IO
import System.Console.ANSI

main = do
  args <- getArgs
  print args
  withFile (args !! 0) ReadMode (\handle0 -> do
    withFile (args !! 1) ReadMode (\handle1 -> do
      guesses <- hGetContents handle0
      answers <- hGetContents handle1
      let guesses' = parse parseResult "Guesses" guesses
          answers' = parse parseAnswers "Answers" answers
       in case (guesses', answers') of
        (Right pGuesses, Right pAnswers) -> run pGuesses pAnswers
      )
    )

run :: [(Declension, [Guess])] -> [[Answer]] -> IO ()
run guesses answers =
  let compared = compareParsed guesses answers
      ansi     = map (unwords . map showParsed) compared
   in mapM_ putStrLn ansi
  where showParsed s = case s of 
                         Right x -> x
                         Left (wrong, right) -> setSGRCode [SetColor Foreground Vivid Red] ++ wrong ++ "(" ++ right ++")" ++ setSGRCode []

   

compareParsed :: [(Declension, [Guess])] -> [[Answer]] -> [[Either (String, String) String]]
compareParsed guesses answers = map (map compareParsed') . wrap $ fill (map snd guesses) answers
  where 
    compareParsed' :: (Guess, Answer) -> Either (String, String) String
    compareParsed' ((Guess x), (Answer y)) = if x == y 
                                               then Right x
                                               else Left (x, y)
    fill :: [[Guess]] -> [[Answer]] -> ([[Guess]], [[Answer]])
    fill x y = 
      let x' = map fill' $ zip x y
       in (x', y)
      where fill' (a, b) = a ++ (take (length b - length a) $ repeat (Guess "_"))

    wrap :: ([[a]], [[b]]) -> [[(a, b)]]
    wrap (x, y) = map (\(x, y) -> zip x y) $ zip x y

