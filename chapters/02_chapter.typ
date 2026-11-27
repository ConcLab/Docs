#import "../common/commonSlide.typ": hint, slide
#import "../common/malloc-graphs/malloc-graph.typ": draw-state


#slide([The Allocation Algorithm])[
  #set align(center + horizon)
  #set text(size: 1.7em)
  == The Allocation Algorithm
]

#slide([The Allocation Algorithm])[
  #set align(center)
  #grid(
    columns: (50%, 50%),
    [
      #set align(left)
      #set text(size: 1.4em)
      - Find an appropriate heap based on the requested size
      - If one is not found, let the OS handle the allocation and return
      - If one _is_ found, try allocating a block from
        + The active superblock
        + A partial superblock
        + A new superblock
        in this order. If all 3 fail, try again.
    ],
    [
      #set text(size: 1.3em)
      ```C
      void* malloc(sz) {
        heap = find heap(sz);
        if (!heap) // Large block
          Allocate block from OS
          and return its address.
        while(1) {
          addr = MallocFromActive(heap);
          if (addr) return addr;
            addr = MallocFromPartial(heap);
          if (addr) return addr;
            addr = MallocFromNewSB(heap);
          if (addr) return addr;
        }
      }
      ```
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center + horizon)
  #set text(size: 1.7em)
  == Allocating from the Active Superblock
]

#slide([Allocating from the Active Superblock])[
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 1: Reserve a block]
      #set text(size: 1.4em)
      // TEXT
      - First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(300%)[
        // DRAW-STATE
        #draw-state(
          credits: 5,
          active-target: 0,
          active-hl: (),
          entries: ()
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    rows: (30%, 40%, 300%),
    [
      #set align(left)
      #set text(size: 1.4em)
      #columns(2)[
        - If *credits > 0*, book a block (reduce credits by one)
        
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      ]
    ],
    [
      #set align(center + horizon)
      #grid(
        columns: (50%, 50%),
        [
          #scale(200%)[
            #draw-state(
              credits: 3,
              active-target: 0,
              active-hl: (),
              entries: ()
            )
          ]

          \
          #scale(200%)[
            #draw-state(
              credits: 2,
              active-target: 0,
              active-hl: (0,),
              entries: ()
            )
          ]
        ],
        [
          #scale(200%)[
            #draw-state(
              credits: 0,
              active-target: 0,
              active-hl: (),
              entries: ()
            )
          ]
          \
          #set text(1.5em)
           $arrow.t$\
          NULL
        ]
      )
    ],
    [
      \
      #set align(left)
      #set text(size: 1.4em)
      *CAS*: try to write the changes to the *Active*. If *not successful*, repeat step 1
    ]
  )
]


#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 2: Pop a block and modify the descriptor]\
      #set text(size: 1.4em)
      
      We first copy the anchor
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: 2,
          active-target: 0,
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      
      Then
      - get the *next available block* from the superblock
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: 2,
          active-target: 0,
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
                hl-desc: (0,),
                hl-sb: (5,),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      
      Then
      - get the *next available block* from the superblock
      - update the next available block with the one contained in it
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: 2,
          active-target: 0,
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (0,),
                hl-sb: (5,),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      
      Then
      - get the *next available block* from the superblock
      - update the next available block with the one contained in it
      - Increment the TAG (to avoid a possible ABA problem)
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: 2,
          active-target: 0,
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 1,
                state: "A",
                tag: "113",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (3,),
                hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.5em)
      // TEXT
      What happens if we take the last credit?
      ```C
        if (oldactive.credits == 0) { // If we took the last credit
          if (oldanchor.count == 0) // If there are no more free blocks
            newanchor.state = FULL;
          else { // If some blocks were freed in the meantime
            // Remove the free blocks from the anchor and store
            // them to update the credits later
            morecredits = min(oldanchor.count,MAXCREDITS);
            newanchor.count -= morecredits;  
          }
        }
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        // DRAW-STATE
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      *CAS*: install the new anchor if the old anchor still
      matches the real one
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: 2,
          active-target: 2,
          active-hl: (1,),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 1,
                state: "A",
                tag: "113",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (),
                hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      *CAS*: install the new anchor if the old anchor still
      matches the real one
      - If they don't match then restart step 2
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: 2,
          active-target: 2,
          active-hl: (1,),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 1,
                state: "A",
                tag: "112",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 1,
                state: "A",
                tag: "113",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (),
                hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      What if we have taken extra credits earlier?

      We need to update the Active
    ],
    [
      #set align(left)
      #text(size: 1.4em)[`morecredits = 4`]
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        // DRAW-STATE
        #draw-state(
          credits: 0,
          active-target: 0,
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      + Create a copy of the old active
    ],
    [
      #set align(left)
      #text(size: 1.4em)[`morecredits = 4`]
      #set align(center + horizon)
      // IMAGES
      #scale(200%)[
        #grid(
          columns: 2,
          column-gutter: 5em,
          [
            #draw-state(
              credits: 0,
              active-target: 0,
              active-hl: (),
              entries: (),
            )
          ],
          [
            #draw-state(
              credits: 0,
              active-target: 0,
              active-label: [New Active],
              active-hl: (),
              entries: (),
            )
          ],
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      + Create a copy of the old active
      + Add the extra credits to the copy (-1 because 0 is a valid credit)
    ],
    [
      #set align(left)
      #text(size: 1.4em)[`morecredits = 4`]
      #set align(center + horizon)
      // IMAGES
      #scale(200%)[
        #grid(
          columns: 2,
          column-gutter: 5em,
          [
            #draw-state(
              credits: 0,
              active-target: 0,
              active-hl: (),
              entries: (),
            )
          ],
          [
            #draw-state(
              credits: 3,
              active-target: 0,
              active-label: [New Active],
              active-hl: (0,),
              entries: (),
            )
          ],
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (40%, 60%),
    [
      #set align(left)
      #set text(size: 1.4em)
      + Create a copy of the old active
      + Add the extra credits to the copy (-1 because 0 is a valid credit)
      + Do a *CAS* to attempt installing the new active if the real one was set to NULL.
        - If it succeeds, the `UpdateActive` returns
        - Otherwise we have to take an extra step
    ],
    [
      #set align(left)
      \
      #text(size: 1.4em)[`morecredits = 4`]
      #set align(center + horizon)
      // IMAGES
      #scale(200%)[
        #grid(
          columns: 2,
          column-gutter: 5em,
          [
            #draw-state(
              credits: 0,
              active-target: 0,
              active-hl: (),
              entries: (),
            )
          ],
          [
            #draw-state(
              credits: 3,
              active-target: 0,
              active-label: [New Active],
              active-hl: (0,),
              entries: (),
            )
          ],
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      If the previous CAS fails then a new Active was installed.\
      We need to "return" the extra credits and set the superblock as `PARTIAL`
    ],
    [
      #set align(left)
      #text(size: 1.4em)[`morecredits = 4`]
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        // DRAW-STATE
        #draw-state(
          credits: 6,
          active-target: 0,
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: none,
                count: none,
                state: none,
                tag: none,
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
        #draw-state(
          credits: 0,
          active-target: 0,
          active-label: [New Active],
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Partial Block Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      Create another set of copies
    
      `morecredits = 4`
    ],
    [
      #text(size: 1.4em)[]
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        // DRAW-STATE
        #draw-state(
          credits: 0,
          active-target: 0,
          active-label: [New Active],
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Partial Block Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      Return the credits to the count and set the block state to `PARTIAL`
    
      `morecredits = 4`
    ],
    [
      #text(size: 1.4em)[]
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        // DRAW-STATE
        #draw-state(
          credits: 0,
          active-target: 0,
          active-label: [New Active],
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Partial Block Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "113",
              ),
              cells: (),
              hl-desc: (1, 2),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Updating the Active])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      *CAS*: install the new anchor for the block if the old
      anchor still matches the current one
      - If it fails, create new copies of the real anchor and
        try again
      - If it succedes, add the superblock to the heap
    
      `morecredits = 4`
    ],
    [
      \
      #text(size: 1.4em)[]
      #set align(center + horizon)
      // IMAGES
      #scale(150%)[
        // DRAW-STATE
        #draw-state(
          credits: 0,
          active-target: 2,
          active-label: [New Active],
          active-hl: (1,),
          entries: (
            (
              desc: (
                label: [Partial Block Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "113",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from the Active Superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (15%, 70%),
    [
      #set align(left)
      #set text(size: 1.6em)
      \

      Finally, we return the addresses of the allocated block
      and the descriptor // TODO: CHECK IF CORRECT
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(190%)[
        // DRAW-STATE
        #draw-state(
          credits: 2,
          active-target: 0,
          active-hl: (1,),
          entries: (
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 1,
                state: "A",
                tag: "113",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (),
                hl-sb: (5,),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center + horizon)
  #set text(size: 1.7em)
  == Allocating from a Partial superblock
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (25%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 1: try getting a Partial superblock]\
      #set text(size: 1.4em)

    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(150%)[
        ```C
        descriptor* HeapGetPartial(heap) {
          do {
            // First, try from the threads procheap
            desc = heap->Partial;
            // Otherwise, try from the Size Class' Partial list
            if (desc == NULL)
              return ListGetPartial(heap->sc);
          } until CAS(&heap->Partial,desc,NULL);
          return desc;
        }
        ```
      ]
    ]
  )
]


#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 2: reserve as many blocks as possible]\
      #set text(size: 1.4em)
      - Copy the new descriptor's anchor
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "E",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 0,
                state: "E",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "E",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 2: reserve as many blocks as possible]\
      #set text(size: 1.4em)
      - Copy the new descriptor's anchor
        - If empty, retry from step 1, else we know that it must be Partial and that \ `count > 0`
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "E",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 0,
                state: "E",
                tag: "594",
              ),
              cells: (),
              hl-desc: (2,),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "E",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      Reserve all available credits, keeping one for the current allocation and saving all the extras
      ```C
        morecredits = 3 // the 0th credits will be handled by UpdateActive
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (1,),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (1,),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      Set the new state to either Active or Empty, depending on whether or not we have extra credits
      ```C
        morecredits = 3 // > 0 so Active
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          active-hl: (),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: (),
              hl-desc: (2,),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      *CAS* operation to install the new anchor. If this fails, retry step 2
      ```C
        morecredits = 3
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 2,
          active-label: "           Desc",
          active-hl: (1,),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 4,
                state: "P",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: (),
              hl-desc: (),
              hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 3: pop a block and update the descriptor]\
      #set text(size: 1.4em)
      - As always, copy the anchor
      ```C
        morecredits = 3
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [Old Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
                hl-desc: (),
                hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 3: pop a block and update the descriptor]\
      #set text(size: 1.4em)
      - As always, copy the anchor
      - Update the next available block
      ```C
        morecredits = 3
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (0,),
                hl-sb: (5,),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 3: pop a block and update the descriptor]\
      #set text(size: 1.4em)
      - As always, copy the anchor
      - Update the next available block
      - Increment the TAG
      ```C
        morecredits = 3
      ```
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 0,
          active-label: "           Desc",
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 0,
                state: "A",
                tag: "595",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (3,),
                hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 3: pop a block and update the descriptor]\
      #set text(size: 1.4em)
      - As always, copy the anchor
      - Update the next available block
      - Increment the TAG
      - Do a *CAS* to install the new anchor if the current one still matches the old one, else retry step 3
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        #draw-state(
          credits: none,
          active-target: 1,
          active-label: "           Desc",
          active-hl: (1,),
          entries: (
            (
              desc: (
                label: [Real Anchor],
                avail: 5,
                count: 0,
                state: "A",
                tag: "594",
              ),
              cells: ("A", "D", "A", "6", "A", "3", "7", "1"),
            ),
            (
              desc: (
                label: [New Anchor],
                avail: 3,
                count: 0,
                state: "A",
                tag: "595",
              ),
              cells: ("A", "D", "A", "6", "A", "A", "7", "1"),
                hl-desc: (),
                hl-sb: (),
            ),
          ),
        )
      ]
    ]
  )
]

#slide([Allocating from a Partial superblock])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (60%, 70%),
    [
      #set align(left)
      #text(size: 1.7em, weight: "bold")[STEP 4: handle remaining credits and return]\
      #set text(size: 1.4em)

      Just like the allocation from the Active superblock, if
      we have extra credits we are going to call
      `UpdateActive` to either:
      - Install this superblock as active with the remaining credits
      - Set the superblock as Partial again and give it back the credits (as `anchor.count`)
      
      \
      In any case, we return the address of the popped block
      plus the address of the descriptor. // TODO: CHECK IF CORRECT
    ],
  )
]

#slide([Allocating from a new superblock])[
  #set align(center + horizon)
  #set text(size: 1.7em)
  == Allocating from a New Superblock
]

#slide([Allocating from a new superblock])[
  #set align(left)
  #set text(size: 1.4em)
  Allocating from a new superblock involves:
  + Allocating the descriptor and superblock given the
    information from the `procheap`'s size class
  + Set the anchor's next available block to 1 so that 0 is
    reserved and the state to `ACTIVE`
  + Do a *CAS*, checking if the active superblock is still
    null and trying to install this new one as active
    // TODO: CHECK IF CORRECT
    - If successful, return the addresses of block 0 and the `desc`
    - If it fails, then someone else has installed a new
      active block. Free the new block and return NULL.
]

// #######################################
// #######################################
// #######################################
// #######################################

/*
#slide([Template slide, REMOVE])[
  #set align(center)
  #grid(
    columns: (100%),
    rows: (30%, 70%),
    [
      #set align(left)
      #set text(size: 1.4em)
      // TEXT
    ],
    [
      #set align(center + horizon)
      // IMAGES
      #scale(170%)[
        // DRAW-STATE
      ]
    ]
  )
]
