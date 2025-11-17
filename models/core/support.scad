// HomeRacker - Core Support
//
// This model is part of the HomeRacker - Core system.
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

include <BOSL2/std.scad>
include <constants.scad>

/* [Parameters] */

// The length of the support in base units (Y-axis, each unit = 15mm).
units = 3; // [1:1:50]

// Add x holes (for printbed interface)
x_holes = false;
/* [Hidden] */
$fn = 100;

lock_pin_center_side = lock_pin_side + printing_layer_width*2;
lock_pin_center_dimension = [lock_pin_center_side, lock_pin_center_side];

lock_pin_outer_side = lock_pin_side + lock_pin_chamfer*2;
lock_pin_outer_dimension = [lock_pin_outer_side, lock_pin_outer_side];

lock_pin_prismoid_inner_length = base_unit/2 - lock_pin_chamfer;
lock_pin_prismoid_outer_length = lock_pin_chamfer;

/**
 * HomeRacker Support Module
 *
 * Parameters:
 *   units (int, default=3): Number of base units (length) for the support.
 *       - Each unit is 15mm tall (see base_unit).
 *       - Typical range: 1 to 50.
 *   x_holes (bool, default=false): If true, adds horizontal holes along the X-axis.
 *
 * Produces:
 *   A support block for the HomeRacker modular rack system.
 *   The block is sized [15mm x (units*15mm) x 15mm] and includes lock pin holes
 *   for each unit of length, allowing secure connection with other components.
 *
 * Usage:
 *   Call support(units) to generate a support of desired length.
 *   Example: support(units=5, x_holes=true);
 */
module support(units=3, x_holes=false) {
    support_dimensions = [base_unit, base_unit*units, base_unit]; // single unit support dimensions

    difference() {
        // Single support block
        color("darkslategray")
        translate([0,units*base_unit/2-base_unit/2,0]) // let the support start from the origin on the y axis centered on the first unit
        cuboid(support_dimensions, chamfer=base_chamfer);

        // Create a lock pin hole for each unit of length
        translate([0,units*base_unit/2-base_unit/2,0])
        ycopies(spacing=base_unit, n=units) {
            // the color is for testing purposes only when someone wants to visualize the hole
            color("red") lock_pin_hole();
        }
        if (x_holes) {
            translate([0,units*base_unit/2-base_unit/2,0])
            ycopies(spacing=base_unit, n=units) {
                // the color is for testing purposes only when someone wants to visualize the hole
                color("red") rotate([0,90,0]) lock_pin_hole();
            }
        }
    }

}

/**
 * 📐 lock_pin_hole module
 *
 * Creates a bidirectional chamfered hole for lock pins, used in HomeRacker connectors and supports.
 * The geometry consists of two mirrored prismoids forming a square hole with chamfered edges on both sides,
 * allowing for easy insertion and secure locking of 4mm square lock pins.
 * This ensures printability and mechanical strength while maintaining standard HomeRacker tolerances.
 */
module lock_pin_hole() {

    // Define one half of the hole shape in a module
    module hole_half() {
        union() {
            prismoid(size1=lock_pin_center_dimension, size2=lock_pin_side_dimension, h=lock_pin_prismoid_inner_length);
            translate([0, 0, lock_pin_prismoid_inner_length]) {
                prismoid(size1=lock_pin_side_dimension, size2=lock_pin_outer_dimension, h=lock_pin_prismoid_outer_length);
            }
        }
    }

    // Render the original half
    hole_half();

    // Render the mirrored half to complete the shape
    mirror([0, 0, 1]) {
        hole_half();
    }
}
