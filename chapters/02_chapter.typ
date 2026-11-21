#import "../common/commonSlide.typ": hint, slide

#slide("A Lock-Free Allocator - Execution (1/q)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        center + horizon
      } else {
        left + horizon
      }
    },
    [
      #image("../img/mdi--format-list-bulleted-square.svg", width: 30%)
    ],
    [
      - When malloc is invoked, based on the size, a Processor Heap with Superblocks of an appropriate size class is searched:
        - The id of the thread is used to discriminate through the various Processor Heaps of the decided size class
      - The malloc function has three prioritized modality to allocate the block:
        - From an Active superblock
        - From a partial superblock
        - From a new superblock
      - Anything can change during execution
        - A loop ensures that at least one of the methods will return a usable address
    ],
  )
]

#slide("A Lock-Free Allocator - Execution (2/q)")[
  #grid(
    columns: (50%, 50%),
    align: (x, y) => {
      if (x == 0) {
        center + horizon
      } else {
        left + horizon
      }
    },
    [
      #image("../img/mdi--format-list-bulleted-square.svg", width: 30%)
    ],
    [
      - When malloc is invoked, based on the size, a Processor Heap with Superblocks of an appropriate size class is searched:
        - The id of the thread is used to discriminate through the various Processor Heaps of the decided size class
      - The malloc function has three prioritized modality to allocate the block:
        - From an *Active* superblock
        - From a *Partial* superblock
        - From a *New* superblock
      - Anything can change during execution
        - A loop ensures that at least one of the methods will return a usable address
      - Non-allocated blocs are linked together, this makes detecting the next free block (*first_available_block* on the *Anchor*) easy and prevents allocating the same block to multiple threads
    ],
  )
]

#slide("Allocating from an Active superblock (1/z)")[
  #grid(
    columns: (50%, 50%),
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
      - First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
    ],
  )
]

#slide("Allocating from an Active superblock (2/z)")[
  #grid(
    columns: (50%, 50%),
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
      + First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      + *CAS*: try to write the changes to the *Active*
        - If *not successful*, repeat point 1
    ],
  )
]

#slide("Allocating from an Active superblock (3/z)")[
  #grid(
    columns: (50%, 50%),
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
      + First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      + *CAS*: try to write the changes to the *Active*
        - If *not successful*, repeat point 1
      + Secondly, copy the *Anchor*
    ],
  )
]

#slide("Allocating from an Active superblock (4/z)")[
  #grid(
    columns: (50%, 50%),
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
      + First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      + *CAS*: try to write the changes to the *Active*
        - If *not successful*, repeat point 1
      + Secondly, copy the *Anchor*
        - Recover the first available block from *first_available_block*
    ],
  )
]

#slide("Allocating from an Active superblock (5/z)")[
  #grid(
    columns: (50%, 50%),
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
      + First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      + *CAS*: try to write the changes to the *Active*
        - If *not successful*, repeat point 1
      + Secondly, copy the *Anchor*
        - Recover the first available block from *first_available_block*
        - Update the *first_available_block* with the value inside the taken block, save the current value
    ],
  )
]

#slide("Allocating from an Active superblock (6/z)")[
  #grid(
    columns: (50%, 50%),
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
      + First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      + *CAS*: try to write the changes to the *Active*
        - If *not successful*, repeat point 1
      + Secondly, copy the *Anchor*
        - Recover the first available block from *first_available_block*
        - Update the *first_available_block* with the value inside the taken block, save the current value
        - Increment the *tag*
    ],
  )
]

#slide("Allocating from an Active superblock (7/z)")[
  #grid(
    columns: (50%, 50%),
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
      + First, the current *Active* section of the Processor Heap is copied
        - If *null*, no Active superblock is present, abort
        - If *credits > 0*, book a block (reduce credits by one)
        - If *credits == 0*, the last block can be booked, set the Active to *null*
      + *CAS*: try to write the changes to the *Active*
        - If *not successful*, repeat point 1
      + Secondly, copy the *Anchor*
        - Recover the first available block from *first_available_block*
        - Update the *first_available_block* with the value inside the taken block, save the current value
        - Increment the *tag*
        - Try to reserve more *credits* for future bookings
          - Only if the current value was 0
          - *number_free_blocks = 0*? Set the state to FULL
    ],
  )
]

#slide("Allocating from an Active superblock (8/z)")[
  #grid(
    columns: (50%, 50%),
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
      #set enum(start: 4)
      + *CAS*: write the new *Anchor*
        - If *not-successful*, retry the point 3
        - Eventually it *must* succeed since booking was succeeded
    ],
  )
]

#slide("Allocating from an Active superblock (9/z)")[
  #grid(
    columns: (50%, 50%),
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
      #set enum(start: 4)
      + *CAS*: write the new *Anchor*
        - If *not-successful*, retry the point 3
        - Eventually it *must* succeed since booking was succeeded
      + *Problem*: if credits were 0 and a thread tried to allocate a block, another superblock may have set *Active* to *null*:
        - *CAS*: try to set *Active* to the current superblock
          - If *not successful*, copy the *Anchor*, reset the *number_free_blocks* and set the state to *Partial*, then *CAS*
    ],
  )
]

#slide("Allocating from an Active superblock (10/z)")[
  #grid(
    columns: (50%, 50%),
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
      #set enum(start: 4)
      + *CAS*: write the new *Anchor*
        - If *not-successful*, retry the point 3
        - Eventually it *must* succeed since booking was succeeded
      + *Problem*: if credits were 0 and a thread tried to allocate a block, another superblock may have set *Active* to *null*:
        - *CAS*: try to set *Active* to the current superblock
          - If *not successful*, copy the *Anchor*, reset the *number_free_blocks* and set the state to *Partial*, then *CAS*
          - *CAS*: Try to put the superblock as *Partial* in the *Processor Heap*. Then put the previously registered Partial superblock in the *Partial list*
      + Return the address of the allocated block
    ],
  )
]

#slide("Allocating from a Partial superblock (1/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (2/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
        - If *found*, copy the *Anchor*
      + Fill the credits for future bookings
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (3/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
        - If *found*, copy the *Anchor*
      + Fill the credits for future bookings
      + Decrease *number_free_blocks* appropriately
        - Normally, by the number of booked credits...
        - ...But a block is reserved for the current thread
      + Verify if it is necessary to set the superblock as Full
        - When *credits = 0*
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (4/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
        - If *found*, copy the *Anchor*
      + Fill the credits for future bookings
      + Decrease *number_free_blocks* appropriately
        - Normally, by the number of booked credits...
        - ...But a block is reserved for the current thread
      + Verify if it is necessary to set the superblock as Full
        - When *credits = 0*
      + *CAS*: try to write the new *Anchor*
        - If *not successful*, repeat from point 1.2
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (5/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
        - If *found*, copy the *Anchor*
      + Fill the credits for future bookings
      + Decrease *number_free_blocks* appropriately
        - Normally, by the number of booked credits...
        - ...But a block is reserved for the current thread
      + Verify if it is necessary to set the superblock as Full
        - When *credits = 0*
      + *CAS*: try to write the new *Anchor*
        - If *not successful*, repeat from point 1.2
      + Copy the just written *Anchor*
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (6/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
        - If *found*, copy the *Anchor*
      + Fill the credits for future bookings
      + Decrease *number_free_blocks* appropriately
        - Normally, by the number of booked credits...
        - ...But a block is reserved for the current thread
      + Verify if it is necessary to set the superblock as Full
        - When *credits = 0*
      + *CAS*: try to write the new *Anchor*
        - If *not successful*, repeat from point 1.2
      + Copy the just written *Anchor*
        - Update the *first_available_block* with the value inside the taken block, save the current value
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (7/l)")[
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
      + Get the Partial superblock of the current Processor Heap
        - If *not found*, abort
        - If *found*, copy the *Anchor*
      + Fill the credits for future bookings
      + Decrease *number_free_blocks* appropriately
        - Normally, by the number of booked credits...
        - ...But a block is reserved for the current thread
      + Verify if it is necessary to set the superblock as Full
        - When *credits = 0*
      + *CAS*: try to write the new *Anchor*
        - If *not successful*, repeat from point 1.2
      + Copy the just written *Anchor*
        - Update the *first_available_block* with the value inside the taken block, save the current value
        - Increment the *tag*
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (8/l)")[
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
      #set enum(start: 7)
      + *CAS*: write the new *Anchor*
        - If *not successful*, repeat from point 6

    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (9/l)")[
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
      #set enum(start: 7)
      + *CAS*: write the new *Anchor*
        - If *not successful*, repeat from point 6
      + *Problem*: superblock should be the newly Active superblock:
      - *CAS*: try to set *Active* to the current superblock
        - If *not successful*, copy the *Anchor*, reset the *number_free_blocks* and set the state to *Partial*, then *CAS*
    ],
    [

    ],
  )
]

#slide("Allocating from a Partial superblock (10/l)")[
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
      #set enum(start: 7)
      + *CAS*: write the new *Anchor*
        - If *not successful*, repeat from point 6
      + *Problem*: superblock should be the newly Active superblock:
      - *CAS*: try to set *Active* to the current superblock
        - If *not successful*, copy the *Anchor*, reset the *number_free_blocks* and set the state to *Partial*, then *CAS*
      + Return the address of the allocated block
    ],
    [

    ],
  )
]


#slide("Allocating from a New superblock (1/v)")[
  #grid(
    columns: (50%, 50%),
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
      + Allocate a superblock from the *Unused* heap
    ],
  )
]

#slide("Allocating from a New superblock (2/v)")[
  #grid(
    columns: (50%, 50%),
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
      + Allocate a superblock from the *Unused* heap
        - Organize the blocks in a linked list
    ],
  )
]

#slide("Allocating from a New superblock (3/v)")[
  #grid(
    columns: (50%, 50%),
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
      + Allocate a superblock from the *Unused* heap
        - Organize the blocks in a linked list
        - Set *first_available_block* to 1
    ],
  )
]

#slide("Allocating from a New superblock (4/v)")[
  #grid(
    columns: (50%, 50%),
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
      + Allocate a superblock from the *Unused* heap
        - Organize the blocks in a linked list
        - Set *first_available_block* to 1
        - Reserve credits for future bookings
    ],
  )
]

#slide("Allocating from a New superblock (5/v)")[
  #grid(
    columns: (50%, 50%),
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
      + Allocate a superblock from the *Unused* heap
        - Organize the blocks in a linked list
        - Set *first_available_block* to 1
        - Reserve credits for future bookings
        - Decrement *number_free_blocks* considering that 1 block is for the current thread
    ],
  )
]

#slide("Allocating from a New superblock (6/v)")[
  #grid(
    columns: (50%, 50%),
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
      + Allocate a superblock from the *Unused* heap
        - Organize the blocks in a linked list
        - Set *first_available_block* to 1
        - Reserve credits for future bookings
        - Decrement *number_free_blocks* considering that 1 block is for the current thread
      + *CAS*: try to set the new superblock as the *Active* one
        - If *not successful*: this means that there was an available superblock, abort
        - If *successful*, return the address of the new block
    ],
  )
]
