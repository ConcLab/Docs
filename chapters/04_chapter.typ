#import "../common/commonSlide.typ": hint, slide

#slide([Performance of the new algorithm])[
  #set align(center + horizon)
  #set text(size: 1.7em)
  == How well does this new algorithm perform?
]


#slide([Performance of the new algorithm])[
  #set align(left)
  #set text(size: 1.7em)
  We want to see how well it does in different circumstances:
  #set text(size: 0.9em)
  \

  - How well it scales under regular allocation patterns
  
  - How well it scales under irregular allocation patterns
  
  - How well it can avoid _false sharing_
  
  - How well it performs under a common real-world workload
]


#slide([Performance of the new algorithm])[
  #set align(left)
  #set text(size: 1.4em)
  Speedup under regular allocation patterns (blocks of the
  same size), testing 10 million malloc/free pairs (left) and
  100 iterations of allocating and freeing 100'000 blocks in
  order (right).

  #set align(center + horizon)
  #grid(
    columns: (50%, 50%),
    [
      #figure(
        image("../img/Benchmarks/Linux scalability.png"),
        caption: [_Linux scalability_],
      )
    ],
    [
      #figure(
        image("../img/Benchmarks/Threadtest.png"),
        caption: [_Threadtest_]
      )
    ]
  )
]

#slide([Performance of the new algorithm])[
  #set align(left)
  #set text(size: 1.4em)
  Speedup under irregular allocation patterns (blocks of
  different sizes, allocated and freed in a random order)
  #set align(center + horizon)
  #figure(
    image("../img/Benchmarks/Larson.png", height: 70%),
    caption: [_Larson_],
  )
]

#slide([Performance of the new algorithm])[
  #set align(left)
  #set text(size: 1.4em)
  Speedup under conditions that may cause false sharing (two
  processors write different words on the same block repeatedly,
  this often degrades the performance of caches)
  #set align(center + horizon)
  #figure(
    image("../img/Benchmarks/Passive false sharing.png", height: 65%),
    caption: [_Passive false sharing_],
  )
]

#slide([Performance of the new algorithm])[
  #set align(left)
  #set text(size: 1.4em)
  Speedup in a producer-consumer workload (a thread allocates
  blocks, passes them to other threads who process the data
  and free them)

  #set align(center + horizon)
  #figure(
    image("../img/Benchmarks/Producer-consumer 1000.png", height: 65%),
    caption: [_Producer-consumer_],
  )
]
