#import "malloc-graph.typ": draw-state

== TEST

#draw-state(
  credits: 5,
  active-target: 0,
  active-hl: (),
  entries: (
    (
      desc: (
        label: [Real Anchor],
        avail: 3,
        count: 8,
        state: "F",
        tag: "1112",
      ),
      cells: ("1", "A", "B", "C", "A", "D", "E", "F"),
      hl-desc: (1, 3),
      hl-sb: (1, 5, 7),
    ),
    (
      desc: (
        label: [Old Anchor],
        avail: 1,
        count: 4,
        state: "A",
        tag: "a",
      ),
      cells: ("A", "A", "A", "A", "B", "C", "D", "E"),
    ),
    (
      desc: (
        label: [New Anchor],
        avail: 1,
        count: 4,
        state: "A",
        tag: "a",
      ),
      cells: ("A", "A", "A", "A", "B", "C", "D", "E"),
    ),
  ),
)
