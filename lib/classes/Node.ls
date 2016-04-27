module.exports = class Node
  ->
    @ <<< it
    @[]prevs
    |> each ~> it.next = @
  op: null
  tensor: null
  next: null
  all_prevs:~ ->
    all_prevs = (node)->
      | not node.prevs? => []
      | _ =>
        node.prevs
        |> (++) (node.prevs |> map all_prevs)
        |> flatten
    all_prevs @
  eval: -> @tensor
  prev_by: (node)->
    | node.next is @ => node
    | _ => @prev_by node.next

