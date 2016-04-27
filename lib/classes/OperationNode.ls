require! {mathjs: math}
require! \./Node.ls

module.exports = class OperationNode extends Node
  op: ""
  prevs: null
  eval: (feeds)->
    @compute feeds
  compute: (feeds)->
    @prevs
    |> map ( .eval feeds)
    |> (
      switch @op
      | \matmul =>
        ([x, y])->
          math.multiply x, y
      | \add =>
        ([x, y])~>
          if math.size y .length < math.size x .length
            y = y |> replicate (math.size x .0)
            @prevs.1.replicated = math.size x .0
          math.add x, y
      | \subtract =>
        ([x, y])->
          if math.size y .length < math.size x .length
            y = y |> replicate (math.size x .0)
            @prevs.1.replicated = math.size x .0
          math.subtract x, y
      | \square =>
        ([x])->
          math.square x
      | \mean =>
        ([x])->
          math.mean x
      | \softmax =>
        ([x])->
          x
          |> map (os)->
            os # outputs
            |> map (o)->
              (math.exp o) / (math.exp os |> math.sum)
    )
  delta_by: (node, feeds)->
    switch
    | node in @prevs =>
      switch @op
      | \mean =>
        @prevs.0.eval feeds
        |> math.size
        |> fold1 (*)
        |> math.pow _, -1
      | \square =>
        @prevs.0.eval feeds
        |> math.multiply _, 2
      | \subtract =>
        switch node
        | @prevs.0 => 1
        | @prevs.1 => -1
      | \softmax =>
        0.5
        # 以下、厳密Ver
#        @prevs.0.eval feeds
#        |> map (row)->
#          row
#          |> map (col)->
#            (row |> reject (is col) |> map ((col + ) >> math.exp) |> sum) / (row |> map math.exp |> sum |> math.square)
      | \add =>
        1
      | \matmul =>
        @prevs
        |> find (isnt node)
        |> ( .eval feeds)
    | _ =>
      @prev_by node
      |> (prev)~>
        [(@delta_by node.next, feeds), (node.next.delta_by node, feeds)]
      |> ([d0, d1])->
        switch
        | (math.size d0) `math.deep-equal` (math.size d1) =>
          zip-with (zip-with (*)), d0, d1
        | (math.size d0).length > 0 and (math.size d1).length >0 =>
          (math.transpose d0) `math.multiply` d1 |> math.transpose
        | _ =>
          d0 `math.multiply` d1
