#import "@preview/cetz:0.5.3" as cetz

#let active-width = 2.0
#let active-cell-width = 1.0
#let active-height = 1
#let desc-width = 3.0
#let sb-cell-width = 0.8
#let block-height = 1.0
#let row-gap = 1.0

#let border-color = rgb("#455468")
#let active-color = rgb("#e5edfa")
#let desc-color = rgb("#f1f3f6")
#let occupied-color = rgb("#f6c86b")
#let empty-color = white

// Generic block
#let block(x, y, w, h, body, fill: white) = {
  import cetz.draw: *
  rect(
    (x, y - h / 2),
    (x + w, y + h / 2),
    stroke: border-color,
    radius: 0.06,
  )
  content((x + w / 2, y), body)
}

// Draw the active
#let active-block(x, y, credits, label: "Active", hl: ()) = {
  import cetz.draw: *

  // Credits cell
  if credits != none {
    rect(
      (x, y - active-height / 2),
      (x + active-cell-width, y + active-height / 2),
      fill: active-color,
      stroke: border-color,
    )

    if hl.contains(0) {
      rect(
        (x + 0.04, y - active-height / 2 + 0.04),
        (x + active-cell-width - 0.04, y + active-height / 2 - 0.04),
        stroke: (paint: red, thickness: 2pt),
      )
    }

    content(
      (x + active-cell-width / 2, y),
      [
        #set align(center)
        #text(size: 7pt, weight: "bold")[credits]
        #linebreak()
        #text(size: 10pt)[#credits]
      ]
    )
  }

  // Pointer cell
  rect(
    (x + active-cell-width, y - active-height / 2),
    (x + active-width, y + active-height / 2),
    fill: desc-color,
    stroke: border-color,
  )

  if hl.contains(1) {
    rect(
      (x + active-cell-width + 0.04, y - active-height / 2 + 0.04),
      (x + active-width - 0.04, y + active-height / 2 - 0.04),
      stroke: (paint: red, thickness: 2pt),
    )
  }

  content(
    (x + active-cell-width * 1.5, y),
    [#text(size: 9pt, weight: "bold")[]],
  )

  // Label
  content(
    (x + active-width / 2, y + active-height / 2 + 0.3),
    [#text(size: 10pt, weight: "bold")[#label]],
  )
}

// Draw a descriptor
#let descriptor(x, y, data, hl: ()) = {
  import cetz.draw: *

  let fields = (
    ("avail", data.avail),
    ("count", data.count),
    ("state", data.state),
    ("tag", data.tag),
    ("sb", " "), // NOT CONSIDERED IN THE WIDTH
  )

  let field-width = desc-width / 4

  for (i, field) in fields.enumerate() {
    let fx = x + i * field-width
    let is-highlighted = hl.contains(i)


    rect(
      (fx, y - block-height / 2),
      (fx + field-width, y + block-height / 2),
      fill: desc-color,
      stroke: border-color,
    )

    if is-highlighted {
      rect(
        (fx + 0.04, y - block-height / 2 + 0.04),
        (fx + field-width - 0.04, y + block-height / 2 - 0.04),
        stroke: (paint: red, thickness: 2pt),
      )
    }

    content(
      (fx + field-width / 2, y),
      [
        #set align(center)
        #text(size: 7pt, weight: "bold")[#field.at(0)]
        #linebreak()
        #text(size: 10pt)[#field.at(1)]
      ],
    )


  }

  content(
    (x + field-width*5 / 2, y + active-height / 2 + 0.3),
    [#text(size: 10pt, weight: "bold")[#data.at("label", default: "")]],
  )
}

// Draw an eight cell superblock
#let superblock(x, y, cells, hl: ()) = {
  import cetz.draw: *

  for (i, value) in cells.enumerate() {
    let cx = x + i * sb-cell-width
    let is-highlighted = hl.contains(i)

    rect(
      (cx, y - block-height / 2),
      (cx + sb-cell-width, y + block-height / 2),
      fill: if value == "A" { occupied-color } else { empty-color },
      stroke: border-color,
    )

    if is-highlighted {
      rect(
        (cx + 0.04, y - block-height / 2 + 0.04),
        (cx + sb-cell-width - 0.04, y + block-height / 2 - 0.04),
        stroke: (paint: red, thickness: 2pt),
      )
    }

    content((cx + sb-cell-width / 2, y), [#value])
  }
}

// Main visualization.
//
// active-target: index of the descriptor pointed to
// entries: array of (desc: (...), cells: (...)) dictionaries
#let draw-state(
  credits: 4,
  active-target: 0,
  active-label: "Active",
  entries: (),
  active-hl: (),
) = {
  let n = entries.len()
  let sb-x = active-width + 1.0 + desc-width + 1.8
  let desc-x = active-width + 1.0
  let total-height = if n == 0 {
    0
  } else {
    (n - 1) * (block-height + row-gap)
  }

  let center-y = total-height / 2

  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Arrow
    set-style(
      stroke: (paint: rgb("#40546b"), thickness: 1.2pt),
      mark: (end: ">"),
    )

    // Descriptor/superblock pairs
    for (i, entry) in entries.enumerate() {
      let y = total-height - i * (block-height + row-gap)

      descriptor(
        desc-x ,
        y,
        entry.desc,
        hl: entry.at("hl-desc", default: ())
      )

      superblock(
        sb-x,
        y,
        entry.cells,
        hl: entry.at("hl-sb", default: ())
      )

      // Descriptor's arrow to the left edge of its superblock
      line(
        (desc-x + desc-width * 1.13, y), // The *1.13 is because the sb cell is not counted in the desc's width
        (sb-x, y),
      )
    }

    // Active structure
    active-block(0, center-y, credits, label: active-label, hl: active-hl)
    // Active's arrow to the selected descriptor
    if n > 0 {
      let target-y = total-height - active-target * (block-height + row-gap)

      line(
        (active-cell-width * 1.5, center-y),
        (desc-x, target-y),
      )
    }
  })
}
