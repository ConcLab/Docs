#import "../common/common.typ": mainColor
#import "../common/commonSlide.typ": hint, slide
#import "@preview/dtree:0.1.1": dtree

#let fillColor = green

#let memFig() = {
  figure(
    kind: image,
    caption: "Computer memory representation",
    text()[
      #v(1em)
      *High memory address*
      #grid(
        stroke: black,
        columns: 50%,
        [
          #v(1em)
          Other regions...
          #v(1em)
        ],
        [
          #v(1em)
          *Stack*
          #v(1em)
        ],
        [
          #v(3em)
        ],
        [
          #v(1em)
          *Heap*
          #v(1em)
        ],
        [
          #v(1em)
          Other regions...
          #v(1em)
        ]
      )
      *Low memory address*
    ],
  )

  place(dx: 48%, dy: -55%)[
    #text(size: 2em)[$arrow.b.filled$]
  ]

  place(dx: 48%, dy: -44%)[
    #text(size: 2em)[$arrow.t.filled$]
  ]
}

#let memAllocSeq(display, capt) = {
  figure(
    kind: image,
    caption: capt,
    text()[
      #v(3em)
      *The Heap*
      #grid(
        stroke: 3pt + black,
        columns: 50%,
        [
          #v(2em)

        ],
        [
          #v(2em)
        ],
        [
          #if (display.at(2) == 1) {
            grid(
              columns: (50%, 50%),
              [
                #move(dx: 1%)[
                  #rect(width: 99%, height: 2em, fill: fillColor)[]
                ]
              ],
              [
                #rect(width: 99%, height: 2em, fill: mainColor)[]
              ],
            )
            place(dx: 48%, dy: -1.5em)[#text(size: 2em)[*?*]]
          } else {
            rect(width: 99%, height: 2em)[]
          }
        ],
        [
          #v(0.1em)
          #if (display.at(1) == 1) {
            rect(width: 99%, height: 1.9em, fill: fillColor)[]
          } else {
            rect(width: 99%, height: 2em)[]
          }
          #v(0.1em)
        ],
        [
          #if (display.at(0) == 1) {
            rect(width: 99%, height: 2em, fill: fillColor)[]
          } else {
            rect(width: 99%, height: 2em)[]
          }
        ],
      )
    ],
  )
}

#slide("Overview")[

]

#slide("Introduction to memory allocation (1/x)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left
      } else {
        center + horizon
      }
    },
    [
      - Upon variable definition, a space for the variable is reserved in memory
        - Specifically, the *Stack* region
        - Grows from high to lower addresses

      - This works with fixed size variables
        - Such us *Integers*, *Booleans*, etc.

      - However, sometime the final size is not known _at priori_
        - Example: a *List* of elements

      - A special region of the memory is available to programmers for *arbitrary* allocation
        - Specifically, the *Heap* region
        - Lower to higher addresses
        - Not directly usable in every programming language
    ],
    [
      #v(50%)
      #memFig()
      #v(50%)
    ],
  )
]

#slide("Introduction to memory allocation (2/x)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left
      } else {
        center + horizon
      }
    },
    [
      - For example, in C, a thread may ask for a portion of the Heap by invoking the *malloc* function

      - *Malloc* reserve the desired portion of the heap and returns a *pointer* (the memory address) of the base of such region

    ],
    [
      #v(50%)
      #memAllocSeq((0, 0, 0), "Heap allocation - Empty Heap")
      #v(50%)
    ],
  )
]

#slide("Introduction to memory allocation (3/x)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left
      } else {
        center + horizon
      }
    },
    [
      - For example, in C, a thread may ask for a portion of the Heap by invoking the *malloc* function

      - *Malloc* reserve the desired portion of the heap and returns a *pointer* (the memory address) of the base of such region

      - For example, if the thread ask for 16 byte of memory, 16 bytes are allocated and, supposing it's the first malloc call of the program, 0x0 is return
        - Then, the program can navigate for 16 bytes over that base address
    ],
    [
      #v(50%)
      #memAllocSeq((1, 0, 0), "Heap allocation - Thread 1 allocate the first block")
      #v(50%)
    ],
  )
]

#slide("Introduction to memory allocation (4/x)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left
      } else {
        center + horizon
      }
    },
    [
      - For example, in C, a thread may ask for a portion of the Heap by invoking the *malloc* function

      - *Malloc* reserve the desired portion of the heap and returns a *pointer* (the memory address) of the base of such region

      - For example, if the thread ask for 16 byte of memory, 16 bytes are allocated and, supposing it's the first malloc call of the program, 0x0 is return
        - Then, the program can navigate for 16 bytes over that base address

      - If only one thread is executed, no problem arise
        - Thread use the heap sequentially
    ],
    [
      #v(50%)
      #memAllocSeq((1, 1, 0), "Heap allocation - Thread 1 allocate the second block")
      #v(50%)
    ],
  )
]

#slide("Introduction to memory allocation (5/x)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left
      } else {
        center + horizon
      }
    },
    [
      - For example, in C, a thread may ask for a portion of the Heap by invoking the *malloc* function

      - *Malloc* reserve the desired portion of the heap and returns a *pointer* (the memory address) of the base of such region

      - For example, if the thread ask for 16 byte of memory, 16 bytes are allocated and, supposing it's the first malloc call of the program, 0x0 is return
        - Then, the program can navigate for 16 bytes over that base address

      - If only one thread is executed, no problem arise
        - Thread use the heap sequentially

      - If multiple thread are running, problem may arise
        - *Heap* effectively become a *contended* region
        - A *special adaptation of malloc* is needed
    ],
    [
      #v(50%)
      #memAllocSeq((1, 1, 1), "Heap allocation - Threads conflict into allocating a block")
      #v(50%)
    ],
  )
]

#slide("2004 Available Solutions")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if x == 0 {
        left + top
      } else {
        center + horizon
      }
    },
    [
      - The standard implementation of malloc is, \ in many systems, *not thread-safe*
        - A _beautiful_ *lock* is acquired upon malloc \
          invocation
    ],
    [
      #image("../img/mdi--lock.svg", width: 20%)
    ],
  )

  #align(center)[*Two alternative were available*]
  #grid(
    columns: (50%, 50%),
    align: left,
    [
      #align(center)[*Ptmalloc*]
      - Created by Wolfram Gloger, based on an allocator created by Doug Lea
      - A better solution than the standard allocator, good results in most of the cases
        - Specifically, the producer-consumer pattern is problematic
        - Memory always returned to the owner (*Blowup problem*)
    ],
    [
      #align(center)[*Hoard*]
      - Created by Emery D. Berger, Kathryn S. McKinley, Robert D. Blumofe, Paul R. Wilson
      - Tries to solve the *Blowup problem* while achieving better results
      - Still some scalability issues on producer-consumer pattern
    ],
  )

  #align(center)[Despite the differences, a common problem: *both still use locks!*]
]

#slide("Goals")[
  #align(center + horizon)[
    #grid(
      columns: (40%, 60%),
      inset: 0.5em,
      align: (x, y) => {
        if x == 0 {
          left + horizon
        } else {
          center + horizon
        }
      },
      [
        - A more appropriate solutions should avoid locks entirely
          - but still allowing to be used concurrently...
          - ...without *deadlocks* and *livelocks*

        - This would allow the algorithm to also be used with *signals*

        - Only widely available instructions should be used
          - like *CAS* or *LL/SC* (the _first_ can be implemented with the _second_)

        - The algorithm should work in a general case, without assumption that would make the function work only in specific cases
      ],
      [

        #image("../img/mdi--format-list-bulleted-square.svg", width: 20%)
        #hint(
          [
            *Note on LL/SC*
            #grid(
              columns: (50%, 50%),
              align: (x, y) => {
                if (y == 0) {
                  center + horizon
                } else {
                  left + top
                }
              },
              [*LL*], [*SC*],
              [
                #v(1em)
                ```
                func LL(addr) {
                  flag(addr)=thread_id
                  return mem[addr]
                }
                ```
              ],
              [
                #v(1em)
                ```
                func SC(addr,val) {
                  if(flag(addr)==thread_id) {
                    mem[addr]=val
                    flag[addr]=null
                    return true
                  }
                  return false
                }
                ```
              ],
            )
          ],
          txtSize: 1em,
        )
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (1/y)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left
      } else {
        center + horizon
      }
    },
    [
      - Designed by *Maged M. Michael*
        - He created, with *Michael L. Scott* the *M&S queue*
        - Does not use locks
        - Uses CAS only
    ],
    [

    ],
  )
]

#slide("A Lock-Free Allocator - Structure (2/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        - Designed by Maged M. Michael
          - Does not use locks
          - Uses CAS only
        - The Heap is divided into *superblocks*
      ],
      [
        #v(50%)
        #figure(
          caption: "Allocator structures - Superblocks",
          image("../img/fig1.svg", width: 60%),
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (3/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        - Designed by Maged M. Michael
          - Does not use locks
          - Uses CAS only
        - The Heap is divided into *superblocks*
        - Each superblock has a descriptor and it is divided into *blocks*
          - Each block of the same superblock has the same size...
          - ...But different superblocks may have blocks of a different size
      ],
      [
        #v(50%)
        #figure(
          caption: "Allocator structures - Blocks",
          image("../img/fig2.svg", width: 80%),
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (4/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        - Designed by *Maged M. Michael*
          - Does *not* use locks
          - Uses CAS only
        - The Heap is divided into *superblocks*
        - Each superblock has a descriptor and it is divided into *blocks*
          - Each block of the same superblock has the same size...
          - ...But different superblocks may have blocks of a different size
        - Superblocks are assigned to different *size classes*, based on their *block size*
      ],
      [
        #v(50%)
        #figure(
          caption: "Allocator structures - Size classes",
          image("../img/fig3.svg", width: 95%),
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (5/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        - Designed by *Maged M. Michael*
          - Does *not* use locks
          - Uses CAS only
        - The Heap is divided into *superblocks*
        - Each superblock has a descriptor and it is divided into *blocks*
          - Each block of the same superblock has the same size...
          - ...But different superblocks may have blocks of a different size
        - Superblocks are assigned to different *size classes*, based on their *block size*
        - Each size class groups its superblocks into groups called *processor heaps*
          - Specifically, as as the number of processors
      ],
      [
        #v(50%)
        #figure(
          caption: "Allocator structures - Processor Heaps",
          kind: image,

          text()[
            #dtree(
              size: 1em,
              ```
              Size Class (size 1)
                Processor Heap 0
                Processor Heap 1
              Size Class (size 2)
                Processor Heap 0
                Processor Heap 1
              ```,
            )
          ],
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (6/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        - Designed by *Maged M. Michael*
          - Does *not* use locks
          - Uses CAS only
        - The Heap is divided into *superblocks*
        - Each superblock has a descriptor and it is divided into *blocks*
          - Each block of the same superblock has the same size...
          - ...But different superblocks may have blocks of a different size
        - Superblocks are assigned to different *size classes*, based on their *block size*
        - Each size class groups its superblocks into groups called *processor heaps*
          - Specifically, as many as the number of processors
        - Each Processor Heap has:
          - 0 or 1 *Active superblocks*
          - 0 or 1 *Partial superblocks*
      ],
      [
        #v(50%)
        #figure(
          caption: "Allocator structures - Processor Heaps members",
          kind: image,

          align(left)[
            #dtree(
              size: 1em,
              ```
              Size Class (size 1)
                Processor Heap 0
                  Superblock (active)
                  Superblock (partial)
                Processor Heap 1
                  Superblock (active)
                  Superblock (partial)
              Size Class (size 2)
                Processor Heap 0
                  Superblock (active)
                  Superblock (partial)
                Processor Heap 1
                  Superblock (active)
                  Superblock (partial)
              ```,
            )
          ],
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (7/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      inset: 0.2em,
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        - As mentioned, a *superblock* may be:
          - *Full* - all blocks are allocated;
          - *Empty* - all blocks are free;
          - *Active* - not Full and the last superblock used by a malloc call on that Processor Heap;
          - *Partial* - not Full and *not* the last superblock used by a malloc call on that Processor Heap;
        - The *Processor Heap* keeps the reference of one *Active* superblock that became *Partial*
          - All of the other are kept in a *M&S FIFO* queue located in the *Size Class*
      ],
      [
        #hint(
          [
            *Note*
            #align(left)[
              A superblock become Partial when:
              - *Thread 1* enters and books a block
              - *Thread 2* enters and tries to book a block but does not succeed
              - *Thread 2* will do the booking on another superblock and set this one as *Active*
              - *Thread 1* notices that *Thread 2* allocated from another superblock, so the superblock of *Thread 2* should be *Active*
              - *Thread 1* sets its superblock as *Partial*
            ]

          ],
          txtSize: 1em,
        )
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (8/y)")[
  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        *Before continuing, some missing details*:
        - The *Size Class* representation is as expected
      ],
      [
        #v(50%)
        #figure(
          kind: image,
          caption: "Size Class details",
          [
            #image("../img/sizeclass.svg")
          ],
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (9/y)")[
  #align(center + horizon)[
    #grid(
      columns: (40%, 60%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        *Before continuing, some missing details*:
        - The *Size Class* representation is as expected
        - For the *Processor Heap*, the *Active* superblock has two data:
          - The pointer to the superblock *descriptor*
          - A *credits* section, useful for booking. It is always set in such a way that if *n* is the memorized number, *n+1* blocks are available
      ],
      [
        #v(50%)
        #figure(
          kind: image,
          caption: "Size class and Processor Heap details",
          [
            #grid(
              columns: (50%, 50%),
              [
                #image("../img/sizeclass.svg")
              ],
              [
                #image("../img/ProcHeap.svg", width: 110%)
              ],
            )
          ],
        )
        #v(50%)
      ],
    )
  ]
]

#slide("A Lock-Free Allocator - Structure (10/y)")[
  #align(center + horizon)[
    #grid(
      columns: (40%, 60%),
      align: (x, y) => {
        if (x == 0) {
          left + top
        } else {
          center + horizon
        }
      },
      [
        *Before continuing, some missing details*:
        - The *Size Class* representation is as expected
        - For the *Processor Heap*, the *Active* superblock has two data:
          - The pointer to the superblock *descriptor*
          - A *credits* section, useful for booking. It is always set in such a way that if *n* is the memorized number, *n+1* blocks are available
        - Superblock *Descriptor* has an *Anchor* with:
          - The index of the first available block
          - The total number of remaining free blocks
          - The state of the superblock
          - A tag (prevents ABA problem)
        - The *Descriptor* itself contains the block size instead
      ],
      [
        #v(50%)
        #figure(
          kind: image,
          caption: [Size class, Processor Heap and Superblock Descriptor \ details],
          [
            #grid(
              columns: (50%, 50%),
              [
                #image("../img/sizeclass.svg")
              ],
              [
                #image("../img/ProcHeap.svg", width: 110%)
              ],
              grid.cell(colspan: 2)[
                #v(1em)
                #image("../img/Descriptor.svg")
              ],
            )
          ],
        )
        #v(50%)
      ],
    )
  ]
]
