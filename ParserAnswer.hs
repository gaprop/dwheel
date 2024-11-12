module ParserAnswer where
import Parser
import Text.ParserCombinators.Parsec
import Text.Parsec.Char

data Answer = Answer String deriving (Show)

parseAnswer :: Parser Answer
parseAnswer = do
  answer <- many1 $ letter <|> char '-' <|> char '/'
  return $ Answer answer

parseLineAnswers :: Parser [Answer]
parseLineAnswers = do
  answers <- sepBy parseAnswer spacesOnly
  return answers

parseAnswers :: Parser [[Answer]]
parseAnswers = do
  answers <- sepBy parseLineAnswers endOfLine
  return answers
