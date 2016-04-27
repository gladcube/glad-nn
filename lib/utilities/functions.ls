require! \shuffle-array

module.exports =
  randomly_take: (n, xs)-->
    shuffle-array.pick xs, picks: n

