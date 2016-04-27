module.exports = class Optimizer
  ->
    @ <<< it
  cost: null
  learning_rate: 1
  variables:~ ->
    @cost.all_prevs
    |> filter ( .@@name is \VariableNode)
  run: (feeds)->
    @minimize @cost, @variables, @learning_rate, feeds
  # Interfaces
  minimize: (cost, variables, learning_rate, feeds)->
    # Minimize cost
