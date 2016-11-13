module Types where

import Prelude
import Data.Lens
import Pux.Html.Events
import Control.Monad.Aff
import Signal.Channel
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Show (class Show)

data Action
  = ToggleEdit
  | AddTextCell
  | AddCodeCell
  | RenderCodeCell Int
  | CheckInput Int FormEvent
  | NoOp

data AppState = AppState
  { editing :: Boolean
  , notebook :: Notebook
  , totalCells :: Int
  , currentCell :: Int
  }

type EffModel state action eff =
  { state :: state
  , effects :: Array (Aff (channel :: CHANNEL, err :: EXCEPTION | eff) action)
  }

_notebook :: Lens' AppState Notebook
_notebook = lens
  (\(AppState s) -> s.notebook)
  (\(AppState s) -> (\n -> AppState (s { notebook = n})))

_totalCells :: Lens' AppState Int
_totalCells = lens
  (\(AppState s) -> s.totalCells)
  (\(AppState s) -> (\n -> AppState (s { totalCells = n})))

_currentCell :: Lens' AppState Int
_currentCell = lens
  (\(AppState s) -> s.currentCell)
  (\(AppState s) -> (\c -> AppState (s { currentCell = c})))

data Notebook = Notebook
  { title :: String
  , subtitle :: String
  , date :: String
  , author :: String
  , cells :: Array Cell
  }

_cells :: Lens' Notebook (Array Cell)
_cells = lens
  (\(Notebook n) -> n.cells)
  (\(Notebook n) -> (\c -> Notebook (n { cells = c})))

data Cell
  = TextCell Int String
  | CodeCell Int String DisplayResult

newtype DisplayResult = DisplayResult String
