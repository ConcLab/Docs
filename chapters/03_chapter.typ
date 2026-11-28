#import "../common/commonSlide.typ": hint, slide

#slide("Freeing a block (1/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Pointer structure",
        image("../img/part3/free-Pointer_struct.drawio.svg"),
      )

    ],
    [
      - While malloc allows to allocate a block, the heap is not an infinite resource
        - Blocks need to be freed
        - This is exactly what *free* does
        - It is the programmer that needs to tell when a block should be freed
      - The *free* function takes the pointer of an allocated block and returns such block to the proper superblock
      - Every blocks has an hidden section of 8 bytes containing the address of its superblock
        - Specifically, the descriptor of such superblock
        - Allocating function return an address incremented by 8 bytes
    ],
  )
]

#slide("Freeing a block (2/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Descriptor recovery",
        image("../img/part3/free-descriptor_recovered.drawio.svg"),
      )
    ],
    [
      + The descriptor of the superblock is recovered
    ],
  )
]

#slide("Freeing a block (3/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Anchor copy",
        image("../img/part3/free-Anchor_recovered.drawio.svg"),
      )
    ],
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
    ],
  )
]

#slide("Freeing a block (4/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - current block index retrieval",
        image("../img/part3/free-Avail_mod.drawio.svg"),
      )
    ],
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* (avail) field of the anchor is set with the current block index
        - The previous value is saved in the block
    ],
  )
]

#slide("Freeing a block (5/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Current state retrieval",
        image("../img/part3/free-State_check.drawio.svg"),
      )
    ],
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* (avail) field of the anchor is set with the current block index
        - The previous value is saved in the block
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
    ],
  )
]

#slide("Freeing a block (6/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Count incrementation",
        image("../img/part3/free-Increment_avail.drawio.svg"),
      )
    ],
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* (avail) field of the anchor is set with the current block index
        - The previous value is saved in the block
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
      + If the superblock is still *Partial*, increment *number_free_blocks* by one
    ],
  )
]

#slide("Freeing a block (7/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Anchor overwrite",
        image("../img/part3/free-CAS_Anchor.drawio.svg"),
      )
    ],
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* (avail) field of the anchor is set with the current block index
        - The previous value is saved in the block
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
      + If the superblock is still *Partial*, increment *number_free_blocks* by one
      + *CAS*: write the new Anchor
        - If *not successful*, repeat from point 2
    ],
  )
]

#slide("Freeing a block (8/9)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Empty Superblock check",
        image("../img/part3/free-CAS_Empty.drawio.svg"),
      )
    ],
    [
      #v(-0.5em)
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* (avail) field of the anchor is set with the current block index
        - The previous value is saved in the block
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
      + If the superblock is still *Partial*, increment *number_free_blocks* by one
      + *CAS*: write the new Anchor
        - If *not successful*, repeat from point 2
      + Check the status of the superblock:
        - If *Empty*, check if it was set as the *Partial* of the heap processor:
          - *CAS*: set to null and queue the descriptor, if *not successful* remove the descriptor entirely
    ],
  )
]

#slide("Freeing a block (9/9)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #figure(
        caption: "Free algorithm - Full Superblock check",
        image("../img/part3/free-CAS_Full.drawio.svg"),
      )
    ],
    [
      #set enum(start: 4)
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
      + If the superblock is still *Partial*, increment *number_free_blocks* by one
      + *CAS*: write the new Anchor
        - If *not successful*, repeat from point 2
      + Check the status of the superblock:
        - If *Empty*, check if it was set as the *Partial* of the heap processor:
          - *CAS*: set to null and queue the descriptor, if *not successful* remove the descriptor entirely
        - If from *Full* became *Partial*
          - *CAS*: Try to put the superblock as *Partial* in the *Processor Heap*. Then put the previously registered Partial superblock in the *Partial list*
    ],
  )
]

#slide("A small note regarding freed superblocks (1/2)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #v(50%)
      #figure(
        caption: "Partial list problem - Example",
        image("../img/part3/free-free_empty.drawio.svg"),
      )
      #v(50%)
    ],
    [
      - If a superblock is *Empty* after a block is freed, the *CAS* to remove it from the *Partial* field of the Processor Heap may fail
        - Maybe when the block was allocated it was in the *Partial* slot of the Processor Heap...
        - ...But later such superblock was moved to the Partial list...
        - ...Therefore, the partial list may be populated with descriptors of *Empty* superblocks
    ],
  )
]

#slide("A small note regarding freed superblocks (2/2)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 1) {
        left + top
      } else {
        center + horizon
      }
    },
    [
      #v(50%)
      #figure(
        caption: "Partial list problem - Solution",
        image("../img/part3/free-free_empty_cleaned.drawio.svg", width: 70.5%),
      )
      #v(50%)
    ],
    [
      - If a superblock is *Empty* after a block is freed, the *CAS* to remove it from the *Partial* field of the Processor Heap may fail
        - Maybe when the block was allocated it was in the *Partial* slot of the Processor Heap...
        - ...But later such superblock was moved to the Partial list...
        - ...Therefore, the partial list may be populated with descriptors of *Empty* superblocks
      - To solve this issue, when the *CAS* fails, the whole list is searched to remove empty descriptors
        - Specifically, a maximum of half of the list is of empty descriptors since the function just start dequeuing until it finds empty descriptors
        - This is to allow the system to be entirely lock-free
    ],
  )
]


#slide("Retrieving descriptors (1/4)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        center + horizon
      } else {
        left + top
      }
    },
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
    ],
    [
      #v(50%)
      #figure(
        caption: "Retrieving descriptors - DescAvail",
        image("../img/part3/free-DescAvail.drawio.svg"),
      )
      #v(50%)
    ],
  )
]

#slide("Retrieving descriptors (2/4)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        center + horizon
      } else {
        left + top
      }
    },
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
      + The current value of *DescAvail* is copied
    ],
    [
      #v(50%)
      #figure(
        caption: "Retrieving descriptors - Descriptor retrieval",
        image("../img/part3/free-CopyDesc.drawio.svg"),
      )
      #v(50%)
    ],
  )
]

#slide("Retrieving descriptors (3/4)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        center + horizon
      } else {
        left + top
      }
    },
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
      + The current value of *DescAvail* is copied
      + *CAS*: modify the *DescAvail* with the next descriptor (accessible by the next pointer)
        - *hazard pointers* are used to prevent ABA
        - If the list was empty a new Descriptor is allocated instead. Change still operated via *CAS*
    ],
    [
      #v(50%)
      #figure(
        caption: "Retrieving descriptors - DescAvail overwrite",
        image("../img/part3/free-CAS_DescAvail.drawio.svg"),
      )
      #v(50%)
    ],
  )
]

#slide("Retrieving descriptors (4/4)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 1) {
        center + horizon
      } else {
        left + top
      }
    },
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
      + The current value of *DescAvail* is copied
      + *CAS*: modify the *DescAvail* with the next descriptor (accessible by the next pointer)
        - *hazard pointers* are used to prevent ABA
        - If the list was empty a new Descriptor is allocated instead. Change still operated via *CAS*
      + *Deallocating* follow the reverse procedure
    ],
    [
      #v(50%)
      #figure(
        caption: "Retrieving descriptors - Final result of Desc retrieval",
        image("../img/part3/free-DescAvail_Final.drawio.svg"),
      )
      #v(50%)
    ],
  )
]
