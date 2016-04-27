require! \./Node.ls

module.exports = class PlaceholderNode extends Node
  name: ""
  eval: (feeds)->
    feeds.(@name)
