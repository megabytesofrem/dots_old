import Data.Monoid
import Control.Monad

-- Single line comment
add :: Int -> Int -> Int
add a b = f a b
  where
    -- yes this is overcomplicated but its to test indentation of where
    f a b = a + b

letIn :: Int -> Int
letIn a = let
  x = a + 42
  in a * 1

main :: IO ()
main = do
  foo $ letIn
  let x = bar baz
  let y = bar . add (2 3)
  someMonad <- mapM_ (+) [1..10]
