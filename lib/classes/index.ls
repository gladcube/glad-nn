require! <[fs]>

module.exports =
  fs.readdir-sync __dirname
  |> filter ( .match /^[^.].*\.ls$/)
  |> reject ( is \index.ls)
  |> map ( .match /(.*)\.ls/ ?.1)
  |> compact
  |> map -> [it, require "./#{it}.ls"]
  |> pairs-to-obj


