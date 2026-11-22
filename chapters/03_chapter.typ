#import "../common/commonSlide.typ": hint, slide

#slide("Freeing a block (1/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
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
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
    ],
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
    ],
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* field of the anchor is set with the current block index
    ],
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* field of the anchor is set with the current block index
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
    ],
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* field of the anchor is set with the current block index
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
      + If the superblock is still *Partial*, increment *number_free_blocks* by one
    ],
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* field of the anchor is set with the current block index
      + State of the superblock is checked:
        - If *Full* revert to *Partial*
        - If *Partial*, check if now the superblock is *Empty* // If non-assigned blocks = maxcount -1 (-1 is the current block being freed)
      + If the superblock is still *Partial*, increment *number_free_blocks* by one
      + *CAS*: write the new Anchor
        - If *not successful*, repeat from point 2
    ],
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      + The descriptor of the superblock is recovered
      + The Anchor of the superblock is copied
      + The *first_available_block* field of the anchor is set with the current block index
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
    [

    ],
  )
]

#slide("Freeing a block (2/x)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
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
    [

    ],
  )
]

#slide("Allocating descriptors (1/y)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        center + horizon
      } else {
        left + horizon
      }
    },
    [

    ],
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
    ],
  )
]

#slide("Allocating descriptors (1/y)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        center + horizon
      } else {
        left + horizon
      }
    },
    [

    ],
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
      + The current value of *DescAvail* is copied
    ],
  )
]

#slide("Allocating descriptors (1/y)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        center + horizon
      } else {
        left + horizon
      }
    },
    [

    ],
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
      + The current value of *DescAvail* is copied
      + *CAS*: modify the *DescAvail* with the next descriptor (accessible by the next pointer)
        - *hazard pointers* are used to prevent ABA
    ],
  )
]

#slide("Allocating descriptors (1/y)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        center + horizon
      } else {
        left + horizon
      }
    },
    [

    ],
    [
      - A pointer called *DescAvail* keeps the start of a *LIFO linked list*
        - The list contains superblocks descriptor that may have a superblock associated to it or not
      + The current value of *DescAvail* is copied
      + *CAS*: modify the *DescAvail* with the next descriptor (accessible by the next pointer)
        - *hazard pointers* are used to prevent ABA
      + *Deallocating* follow the reverse procedure
    ],
  )
]

#slide("A small note regarding freed superblocks (1/z)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      - If a superblock is *Empty* after a block is freed, the *CAS* to remove it from the *Partial* field of the superblock may fail
        - Maybe when the block was allocated it was in the *Partial* slot of the Processor Heap...
        - ...But later such superblock was moved to the Partial list...
        - ...Therefore, the partial list may be populated with descriptors of *Empty* superblocks
    ],
    [
    ],
  )
]

#slide("A small note regarding freed superblocks (2/z)")[
  #grid(
    columns: (50%, 50%),
    inset: 1em,
    align: (x, y) => {
      if (x == 0) {
        left + horizon
      } else {
        center + horizon
      }
    },
    [
      - If a superblock is *Empty* after a block is freed, the *CAS* to remove it from the *Partial* field of the superblock may fail
        - Maybe when the block was allocated it was in the *Partial* slot of the Processor Heap...
        - ...But later such superblock was moved to the Partial list...
        - ...Therefore, the partial list may be populated with descriptors of *Empty* superblocks
      - To solve this issue, when the *CAS* fails, the whole list is searched to remove empty descriptors
        - Specifically, a maximum of half of the list is of empty descriptors since the function just start dequeuing until it finds empty descriptors
        - This is to allow the system to be entirely lock-free
    ],
    [
    ],
  )
]
