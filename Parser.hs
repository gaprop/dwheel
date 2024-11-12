module Parser where
import Text.ParserCombinators.Parsec
import Text.Parsec.Char

-- data Declension = Word String
                -- | Answer String
                -- deriving (Show)

data Guess = Guess String deriving (Show)
data Declension = Word String deriving (Show)

spacesOnly :: Parser String
spacesOnly = many1 $ oneOf " \t"

empyLine :: Parser String
empyLine = do
  many1 endOfLine
  -- fmap return endOfLine

commentsOnly :: Parser String
commentsOnly = do 
  string "--"
  manyTill anyChar $ try endOfLine
  -- fmap return endOfLine

parseDeclension :: Parser Declension
parseDeclension = do
  -- spaces
  word <- many $ noneOf ": "
  char ':'
  return $ Word word

parseGuess :: Parser Guess
parseGuess = do
  guess <- many1 $ letter <|> char '-' <|> char '/'
  return $ Guess guess

parseGuesses :: Parser [Guess]
parseGuesses = do
  guesses <- sepBy parseGuess spacesOnly
  return guesses

parseLine :: Parser (Declension, [Guess])
parseLine = do
  declension <- parseDeclension
  many spacesOnly
  guesses <- parseGuesses
  return (declension, guesses)

parseResult :: Parser [(Declension, [Guess])]
parseResult = do
  many $ commentsOnly <|> empyLine
  lines <- sepEndBy parseLine (many1 $ commentsOnly <|> empyLine)
  return lines
