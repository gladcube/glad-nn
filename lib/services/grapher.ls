require! {mathjs: math}
{rnorm} = require \randgen
require! [
  \../classes/Node.ls
  \../classes/PlaceholderNode.ls
  \../classes/OperationNode.ls
  \../classes/VariableNode.ls
  \../classes/GradientDescentOptimizer.ls
]

module.exports = new class Grapher
  placeholder: placeholder = (name, shape)->
    new PlaceholderNode name: name, shape: shape
  constant: constant = (tensor)->
    new Node tensor: tensor, shape: math.size tensor
  op: op = (type, ...nodes)->
    new OperationNode do
      op: type
      prevs: nodes
  softmax: softmax = (x)->
    op \softmax, x
  matmul: matmul = (x, y)-->
    op \matmul, x, y
  add: add = (x, y)-->
    op \add, x, y
  subtract: subtract = (x, y)-->
    op \subtract, x, y
  square: square = (x)->
    op \square, x
  mean: mean = (x)->
    op \mean, x
  variable: variable = (name, tensor)->
    new VariableNode name: name, tensor: tensor
  optimize: optimize = (cost, learning_rate)->
    new GradientDescentOptimizer learning_rate: learning_rate, cost: cost
  randoms: randoms = ([x]:shape, mean, sd)->
    | shape.length is 1 => [0 til x] |> map -> rnorm mean, sd
    | shape.length > 1 =>
      [0 til x]
      |> map -> randoms (shape |> drop 1)
    | _ => []
  zeros: zeros = ([x]:shape)->
    | shape.length is 1 => [0 til x] |> map -> 0
    | shape.length > 1 =>
      [0 til x]
      |> map -> zeros (shape |> drop 1)
    | _ => []
