// HomeRacker - Core Panel
//
// This model is part of the HomeRacker - Core system.
//
// MIT License
// Copyright (c) 2025 Patrick Pötz
// Copyright (c) 2025 Pierre Hans Corcoran
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

/**
 * HomeRacker Panel Module
 *
 *           top
 *           ____ 
 *         _|____|_
 *        _|      |_
 *       | |      | |
 *  left | |      | | right
 *       | |      | |
 *       |_|      |_|
 *         |______|
 *          |____| 
 *          bottom
 *
 * Parameters:
 *   dimensions (list(int), default=[5, 5]): Number of base units (X, Y) for the panel.
 *       - Each unit is 15mm in length along each axis (see base_unit).
 *       - Panel height (Z-axis) is always 15mm on the edges
 *       - Panel thickness (Z-axis) is always 4mm in the center
 *
 *   ears (list(string), default=["half", "half", "half", "half"]): Adds "ears" in the top, right, bottom & left dimensions
 *       - Ears are sections that protrude horizontally off the edges of the panel to rest on supports, flush with the connectors
 (X, Y; none, half, full)
 *       - Ears are specified as one of the following values, with default "half"
 *           + half: the ears extend over the support, up to the pin hole but not over it
 *           + full: the ears extend over the support, for the full width of the support
 *           + none: no ears extend over the support
 *       - Ears are defined using 4 values, e.g. ["half", "none", "full", "none"], which defines top as "half", right as "none", bottom as "full" and left as "none"
 *
 *  pattern (string, default="hexgrid"): Pattern of holes for the panel
 *       - Panel has a pattern of holes to reduce material usage
 *       - Pattern can be "hexgrid" or "plain"
 *       - Plain means no holes
 *
 * Produces:
 *   A panel for the HomeRacker modular rack system.
 *   The panel is sized [(dimensions[0]*15mm) x (dimensions[1]*15mm) x 4mm] and includes lock pin holes
 *   for each unit of length, allowing secure connection with other components.
 *
 * Usage:
 *   Call panel(dimensions, ears, pattern) to generate a panel of desired dimensions.
 *   Example: panel(dimensions=[5, 5], ears=["half", "half", "half", "half"], pattern="hexgrid");
 */
module panel(dimensions=[5, 5], ears=["half", "half", "half", "half"], pattern="hexgrid") {
    epsilon = 0.01;
    panel_dimensions = [BASE_UNIT*dimensions[0] - TOLERANCE, BASE_UNIT*dimensions[1] - TOLERANCE, BASE_UNIT + BASE_STRENGTH];
    panel_thickness = BASE_STRENGTH*2;
    lock_pin_outer_side = LOCKPIN_HOLE_SIDE_LENGTH + LOCKPIN_HOLE_CHAMFER*2;
    lock_pin_outer_dimension = [lock_pin_outer_side, lock_pin_outer_side];
    lock_pin_prismoid_inner_length = BASE_UNIT/2 - LOCKPIN_HOLE_CHAMFER;
    lock_pin_prismoid_outer_length = LOCKPIN_HOLE_CHAMFER;
    hex_pattern_radius = (BASE_UNIT/2-BASE_STRENGTH)/cos(30);
    hex_pattern_border = BASE_UNIT/2;
    hex_spacing = 2 * (hex_pattern_radius*cos(30) + BASE_STRENGTH);
    hex_pattern_box = [floor((panel_dimensions[0] - hex_pattern_border + BASE_STRENGTH) / hex_spacing)*hex_spacing, floor((panel_dimensions[1] - hex_pattern_border + BASE_STRENGTH) / hex_spacing)*hex_spacing];
    hex_limits = [floor(panel_dimensions[0] / hex_spacing), floor(panel_dimensions[1] / hex_spacing)];
    connector_outer_side_length = BASE_UNIT + BASE_STRENGTH*2 + TOLERANCE;
    cutout_reinforcement_width = hex_pattern_border;
    cutout_reinforcement_thickness = BASE_STRENGTH;
    // This is to eventually support partial approaches for connector cutouts. 
    cutout_plan = [
        [-1, 1],
        [-1, 1],
    ];

    ear_dimensions = [
        (
            BASE_UNIT * dimensions[0]
            + (ears[0] == "full" ? BASE_UNIT : 0)
            + (ears[0] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
            + (ears[3] == "full" ? BASE_UNIT : 0)
            + (ears[3] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
        ),
        (
            BASE_UNIT * dimensions[1]
            + (ears[1] == "full" ? BASE_UNIT : 0)
            + (ears[1] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
            + (ears[2] == "full" ? BASE_UNIT : 0)
            + (ears[2] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
        ),
        BASE_STRENGTH,
    ];
    ear_offsets = [
        0.5 * (
            0
            + (ears[0] == "full" ? BASE_UNIT : 0)
            + (ears[0] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
            - (ears[3] == "full" ? BASE_UNIT : 0)
            - (ears[3] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
        ),
        0.5 * (
            0
            + (ears[1] == "full" ? BASE_UNIT : 0)
            + (ears[1] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
            - (ears[2] == "full" ? BASE_UNIT : 0)
            - (ears[2] == "half" ? 0.5 * (BASE_UNIT - LOCKPIN_HOLE_SIDE_LENGTH) : 0)
        ),
        BASE_UNIT/2 - epsilon,
    ];

    difference() {
        union() {
            difference() {
                color("darkslategray")
                union() {
                    // Panel block
                    cuboid(panel_dimensions, chamfer=BASE_CHAMFER);

                    // Ear block
                    translate(ear_offsets)
                        cuboid(ear_dimensions, chamfer=BASE_CHAMFER);
                }

                // Create a +/-X lock pin hole for each unit of length
                for(i=[-1, 1]) {
                    translate([i*(panel_dimensions[0] + BASE_UNIT - 2*BASE_STRENGTH)/2, 0, -(BASE_STRENGTH + TOLERANCE)/2]) rotate(i*[0, -90, 0]) {
                        ycopies(spacing=BASE_UNIT, n=dimensions[1]) {
                            // the color is for testing purposes only when someone wants to visualize the hole
                            color("red")
                            translate([0, 0, lock_pin_prismoid_inner_length + epsilon - TOLERANCE*2]) {
                                prismoid(size1=LOCKPIN_HOLE_SIDE_LENGTH_DIMENSION, size2=lock_pin_outer_dimension, h=lock_pin_prismoid_outer_length + TOLERANCE*2);
                                cube([LOCKPIN_HOLE_SIDE_LENGTH, LOCKPIN_HOLE_SIDE_LENGTH, LOCKPIN_HOLE_SIDE_LENGTH], center=true);
                            }
                        }
                    }
                }

                // Create a +/-Y lock pin hole for each unit of length
                for(i=[-1, 1]) {
                    translate([0, i*(panel_dimensions[1] + BASE_UNIT - 2*BASE_STRENGTH)/2, -(BASE_STRENGTH + TOLERANCE)/2]) rotate(i*[-90, 0, 0]) {
                        xcopies(spacing=BASE_UNIT, n=dimensions[0]) {
                            // the color is for testing purposes only when someone wants to visualize the hole
                            color("red")
                            mirror([0, 0, 1])
                            translate([0, 0, lock_pin_prismoid_inner_length + epsilon - TOLERANCE*2]) {
                                prismoid(size1=LOCKPIN_HOLE_SIDE_LENGTH_DIMENSION, size2=lock_pin_outer_dimension, h=lock_pin_prismoid_outer_length + TOLERANCE*2);
                                cube([LOCKPIN_HOLE_SIDE_LENGTH, LOCKPIN_HOLE_SIDE_LENGTH, LOCKPIN_HOLE_SIDE_LENGTH], center=true);
                            }
                        }
                    }
                }

                // Hollow out center
                translate([0, 0, -BASE_STRENGTH/2])
                    cuboid(
                        [
                            panel_dimensions[0] - 2*BASE_STRENGTH,
                            panel_dimensions[1] - 2*BASE_STRENGTH,
                            BASE_UNIT + epsilon,
                        ],
                        chamfer=-BASE_CHAMFER, edges=BOTTOM
                    );

                // Grid pattern across horizontal surface
                if(pattern == "hexgrid") {
                    intersection() {
                        cube([hex_pattern_box[0], hex_pattern_box[1], BASE_UNIT+BASE_STRENGTH+epsilon], center=true);
                        for(i=[-hex_limits[0]-1:1:hex_limits[0]+1], j=[-hex_limits[1]-1:1:hex_limits[1]+1]) {
                            translate([i*hex_spacing*cos(30), (j+abs(i%2)/2)*hex_spacing, 0])
                                linear_extrude(height = 20, center = true)
                                regular_polygon(order=6, r=hex_pattern_radius);
                        }
                    }
                }
            }

            // X-axis Reinforcement
            for(i=cutout_plan[0], j=cutout_plan[1]) {
                intersection() {
                    translate([
                        i*(panel_dimensions[0]/2 - epsilon),
                        j*(panel_dimensions[1]/2 - cutout_reinforcement_thickness/2 - connector_outer_side_length + 2*BASE_STRENGTH + TOLERANCE/2 - epsilon),
                        -BASE_UNIT/2 - 2*BASE_STRENGTH - epsilon,
                    ])
                        rotate([90, 0, 0])
                        linear_extrude(height = cutout_reinforcement_thickness, center = true)
                        polygon([
                            [-i*cutout_reinforcement_width, BASE_UNIT + 2*BASE_STRENGTH],
                            [0, BASE_UNIT + 2*BASE_STRENGTH],
                            [0, 0],
                        ]);
                
                    translate([
                        i*(panel_dimensions[0]/2 - BASE_UNIT/2 - BASE_STRENGTH/2 - epsilon),
                        j*(panel_dimensions[1]/2 - cutout_reinforcement_thickness/2 - connector_outer_side_length + BASE_STRENGTH + TOLERANCE/2 - epsilon),
                        -BASE_STRENGTH/2 + epsilon,
                    ])
                        cube([BASE_UNIT, BASE_UNIT, BASE_UNIT], center=true);
                }
            }

            // Y-axis Reinforcement
            for(i=cutout_plan[0], j=cutout_plan[1]) {
                intersection() {
                    translate([
                        i*(panel_dimensions[0]/2 - cutout_reinforcement_thickness/2 - connector_outer_side_length + 2*BASE_STRENGTH + TOLERANCE/2 - epsilon),
                        j*(panel_dimensions[1]/2 - epsilon),
                        -BASE_UNIT/2 - 2*BASE_STRENGTH - epsilon,
                    ])
                        rotate([90, 0, i*j*90])
                        linear_extrude(height = cutout_reinforcement_thickness, center = true)
                        polygon([
                            [-i*cutout_reinforcement_width, BASE_UNIT + 2*BASE_STRENGTH],
                            [0, BASE_UNIT + 2*BASE_STRENGTH],
                            [0, 0],
                        ]);
                
                    translate([
                        i*(panel_dimensions[0]/2 - cutout_reinforcement_thickness/2 - connector_outer_side_length + BASE_STRENGTH + TOLERANCE/2 - epsilon),
                        j*(panel_dimensions[1]/2 - BASE_UNIT/2 - BASE_STRENGTH/2 - epsilon),
                        -BASE_STRENGTH/2 + epsilon,
                    ])
                        cube([BASE_UNIT, BASE_UNIT, BASE_UNIT], center=true);
                }
            }
        } // end union()

        // Cutouts for connectors
        for(i=cutout_plan[0], j=cutout_plan[1]) {
            translate([
                i*(panel_dimensions[0]/2 + BASE_UNIT/2),
                j*(panel_dimensions[1]/2 + BASE_UNIT/2),
                0,
            ])
                cuboid([connector_outer_side_length, connector_outer_side_length, BASE_UNIT + BASE_STRENGTH + epsilon], chamfer=-BASE_CHAMFER);
            translate([
                i*(panel_dimensions[0]/2 - BASE_UNIT/2 + BASE_STRENGTH),
                j*(panel_dimensions[1]/2 + BASE_UNIT/2),
                0,
            ])
                cuboid([connector_outer_side_length, connector_outer_side_length, BASE_UNIT + BASE_STRENGTH + epsilon], chamfer=-BASE_CHAMFER);
            translate([
                i*(panel_dimensions[0]/2 + BASE_UNIT/2),
                j*(panel_dimensions[1]/2 - BASE_UNIT/2 + BASE_STRENGTH),
                0,
            ])
                cuboid([connector_outer_side_length, connector_outer_side_length, BASE_UNIT + BASE_STRENGTH + epsilon], chamfer=-BASE_CHAMFER);
        }
    } // end difference()
}

module regular_polygon(order = 6, r=1){
     angles=[ for (i = [0:order-1]) i*(360/order) ];
     coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
     polygon(coords);
 }
