require! {mathjs: math}
require! \./Optimizer.ls

module.exports = class GradientDescentOptimizer extends Optimizer
  minimize: (cost, variables, learning_rate, feeds)->
    variables
    |> map (variable)->
      # if variable.name is \b => return
      cost.delta_by variable, feeds
      |> math.multiply _, learning_rate
      |> (
        # For bias
        if variable.replicated > 0
          math.transpose >> (map math.mean)
        else id
      )
      |> -> [variable, it]
    |> each ([variable, delta])->
      variable.tensor = math.subtract variable.tensor, delta
    return @

