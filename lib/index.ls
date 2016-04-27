require! \./classes/
require! \./services/

module.exports
  <<<
    run: (optimizer, feeds)->
      optimizer.run feeds
    eval: _eval = (node, feeds)->
      | node |> is-type \Array => (nodes = node) |> map (_eval _, feeds)
      | _ => node.eval feeds
  <<<
    <[placeholder constant softmax
      matmul add subtract square
      mean variable optimize randoms
      zeros]>
    |> map -> [it, services.grapher.(it)]
    |> pairs-to-obj
  <<<
    classes
