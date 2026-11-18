#import "../common/common.typ": mainColor
#import "../common/commonSlide.typ": slide

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

  place(dx: 48%, dy: -62%)[
    #text(size: 2em)[$arrow.b.filled$]
  ]

  place(dx: 48%, dy: -48%)[
    #text(size: 2em)[$arrow.t.filled$]
  ]
}

#let memAllocSeq(display) = {
  figure(
    kind: image,
    caption: "Heap allocation",
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
      #memFig()
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
      #memAllocSeq((0, 0, 0))
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
      #memAllocSeq((1, 0, 0))
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
      #memAllocSeq((1, 1, 0))
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
      #memAllocSeq((1, 1, 1))
    ],
  )
]
