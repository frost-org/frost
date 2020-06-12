module Frost.Plugins.StackPlugins where

import           Data.Text
import           Frost.Effects.Stack
import           Frost.Plugin
import           Polysemy
import           Text.Pandoc

stackPlugin :: (Member Stack r) => Text -> Sem r Text -> Plugin r
stackPlugin pluginName stackCommand =
  justContentPlugin pluginName (\_ -> do
    output <- stackCommand
    return (renderBlock output, []))
  where
    renderBlock output = [CodeBlock ("", [], []) output]

stackBuildPlugin :: (Member Stack r) => Plugin r
stackBuildPlugin = stackPlugin "stack:build" build

stackTestPlugin :: (Member Stack r) => Plugin r
stackTestPlugin = stackPlugin "stack:test" test

stackPlugins :: (Member Stack r) => [Plugin r]
stackPlugins = [stackBuildPlugin, stackTestPlugin]
