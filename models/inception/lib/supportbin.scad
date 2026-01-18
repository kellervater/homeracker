// HomeRacker - Support Bin
//
// This file is part of HomeRacker implementation by KellerLab.
// It contains the support bin module to create Gridfinity-compatible bins to store HomeRacker supports.
//
// MIT License
// Copyright (c) 2025 Patrick Pötz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

include <../../gridfinity/lib/binbase.scad>
include <../../gridfinity/lib/constants.scad>
include <../../core/lib/constants.scad>

/* [Parameters] */

// x dimensions (in multiples of 42mm)
grid_x = 2; // [1:1:17]
// y dimensions (in multiples of 42mm)
grid_y = 2; // [1:1:10]

/* [Advanced] */
// thickness of the dividers between cells
divider_strength = 1.2; // [1.0:0.1:3.0]

/* [Hidden] */
// Optimized for 0.4mm nozzle 3D printing (allegedly according to Sonnet 4.5's research)
// Preview: Faster but still smooth
// Render: Based on typical 0.4mm nozzle capabilities
$fs = $preview ? 0.8 : 0.4;
$fa = $preview ? 6 : 2;
EPSILON = 0.01; // small value to avoid z-fighting

/** * Calculate the difference between the Gridfinity pocket grid length and the actual length occupied by the support units.
 * If positive, there is extra space; if negative, the supports won't fit and you need to subtract 1 support unit.
 *
 * @param units Number of Gridfinity units
 * @return Difference in mm
 */
function get_gridfinity_pocketgrid_diff(gridfinity_units, support_units) =
  let(
    length = GRIDFINITY_BASE_UNIT * gridfinity_units - BINBASE_SUBTRACTOR,
    support_unit = BASE_UNIT + divider_strength + TOLERANCE
  )
  length - (support_units*support_unit+divider_strength);

/** * Calculate the number of support units that fit into the given Gridfinity units.
 *
 * @param units Number of Gridfinity units
 * @return Number of support units that fit
 */
function support_per_gridfinity_unit(units) =
  let(
    length = GRIDFINITY_BASE_UNIT * units - BINBASE_SUBTRACTOR,
    support_unit = BASE_UNIT + divider_strength + TOLERANCE,
    supports_net = floor(length / support_unit)
  )
  (supports_net*support_unit+divider_strength) > length ? supports_net-1 : supports_net;

SP_OUTER_WIDTH = BASE_UNIT + divider_strength*2 + TOLERANCE;
SP_DEFAULT_HEIGHT = BASE_UNIT/2;

module support_pocket(height=SP_DEFAULT_HEIGHT, anchor=CENTER, spin=0, orient=UP) {
  inner_width = BASE_UNIT + TOLERANCE;

  attachable(anchor=CENTER, spin=0, orient=UP, size=[SP_OUTER_WIDTH, SP_OUTER_WIDTH, height]) {
    diff() cuboid([SP_OUTER_WIDTH,SP_OUTER_WIDTH, height])
      tag("remove") cuboid([inner_width,inner_width, height+EPSILON]);
    children();
  }
}

module pocket_grid(supports_x, supports_y, height=SP_DEFAULT_HEIGHT, rounding=BB_TOP_PART_ROUNDING, anchor=CENTER, spin=0, orient=UP) {
  spacing = SP_OUTER_WIDTH-divider_strength; // creates an overlap to ensure uniform wall thickness (inner vs outer)

  length_x = spacing*supports_x+divider_strength;
  length_y = spacing*supports_y+divider_strength;
  attachable(anchor=CENTER, spin=0, orient=UP, size=[length_x, length_y, height]){
    diff()
    cuboid([length_x, length_y, height], rounding=rounding, except=[BOTTOM,TOP])
      tag("remove")
      grid_copies(n=[supports_x, supports_y], spacing=spacing)
        cuboid([BASE_UNIT + TOLERANCE, BASE_UNIT + TOLERANCE, height+EPSILON]);
    children();
  }
}

supports_x = support_per_gridfinity_unit(grid_x);
supports_y = support_per_gridfinity_unit(grid_y);

bigger_rounding_diff = max(get_gridfinity_pocketgrid_diff(grid_x, supports_x), get_gridfinity_pocketgrid_diff(grid_y, supports_y));
rounding_diff = bigger_rounding_diff > BB_TOP_PART_ROUNDING ? BB_TOP_PART_ROUNDING*2 : bigger_rounding_diff;

color_this(HR_BLUE)
binbase_with_topplate(grid_x, grid_y, 1)
attach(TOP,BOTTOM)
color_this(HR_YELLOW)
pocket_grid(supports_x, supports_y, rounding=BB_TOP_PART_ROUNDING-rounding_diff/2);
