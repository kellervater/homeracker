// HomeRacker - Core Lock Pin
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

$fn = 100;

grip_type = "standard"; // ["standard", "no_grip"]

// Lock Pin Dimensions

// lockpin_fillet_front = lockpin_width_outer / 3;
lockpin_chamfer = printing_layer_width;
// lockpin_grip_thickness_inner = printing_layer_width*2;
// lockpin_grip_thickness_outer = base_strength / 2;
// lockpin_grip_distance = base_strength / 2;
// lockpin_grip_width = lockpin_width + base_strength*2;
// lockpin_tension_hole_width_inner = printing_layer_width*4; // widest/middle point of the tension hole

lockpin_width_outer = lockpin_hole_side_length;
lockpin_width_inner = lockpin_hole_side_length + printing_layer_width * 2;
lockpin_height = lockpin_width_outer - tolerance;
lockpin_prismoid_length = (base_unit - base_strength) / 2;

module lockpin(grip_type = "standard") {
  difference() {
    // Create the lockpin shape
    union() {
      // Mid part (outer shape)
      color(HR_YELLOW)
      tension_shape();
      // End part
      end_parts(grip_type);
    }
    // Subtract the tension hole
    color(HR_RED)
    tension_hole();
  }
}

module end_parts(grip_type = "standard") {
  end_part_half(true);
  mirror([0, 0, 1]) end_part_half(grip_type == "no_grip");
}

module end_part_half(front = false) {
  lockpin_endpart_length = base_strength + base_strength / 2 + tolerance/2;
  lockpin_fillet_front = lockpin_width_outer / 3;
  lockpin_endpart_dimension = [lockpin_width_outer, lockpin_height, lockpin_endpart_length]; // cubic

  translate([0, 0, lockpin_prismoid_length + lockpin_endpart_length / 2])
  color(HR_BLUE)
  // Since it's not possible to have both chamfer and fillet on the same edges,
  // we use an intersection of two shapes to achieve the desired effect.
  intersection() {
    cuboid(lockpin_endpart_dimension, rounding=front ? lockpin_fillet_front : 0, edges=[TOP + LEFT, TOP + RIGHT]);
    cuboid(lockpin_endpart_dimension, chamfer=lockpin_chamfer, edges=[FRONT,BACK], except=BOTTOM);
  }
}

/**
 * 📐 tension_shape module
 *
 * Creates the main body of the lock pin with chamfered prismoid shape.
 * TODO(Challenge): Add fillets to the adjoining edges of both tension_shape_halfs.
 * I haven't found a clean way to do this using BOSL2 yet (only ways that bloat the code significantly).
 * I think it'll work without fillets here for now.
 */
module tension_shape() {
    tension_shape_half();
    mirror([0, 0, 1]) tension_shape_half();
}

module tension_shape_half() {
  lockpin_inner_dimension = [lockpin_width_inner, lockpin_height]; // planar
  lockpin_outer_dimension = [lockpin_width_outer, lockpin_height]; // planar
  lockpin_fillet_sides = base_unit;

  prismoid(lockpin_inner_dimension, lockpin_outer_dimension, height=lockpin_prismoid_length, chamfer=lockpin_chamfer);
}

module tension_hole(){
  tension_hole_half();
  mirror([0,0,1]) tension_hole_half();
}

module tension_hole_half(){
  lockpin_tension_angle = 86.5; // in degrees
  lockpin_tension_hole_width_inner = printing_layer_width * 4; // widest/middle point of the tension hole
  lockpin_tension_hole_height = base_unit / 2;
  lockpin_tension_hole_inner_dimension = [lockpin_tension_hole_width_inner, lockpin_height]; // planar
  prismoid(size1=lockpin_tension_hole_inner_dimension, height=lockpin_tension_hole_height, xang=lockpin_tension_angle, yang=90);
}



lockpin(grip_type);
