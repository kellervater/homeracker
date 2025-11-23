include <BOSL2/std.scad>

/* [Parameters] */

// The length (Y-axis) of the support in base units.
units = 3; // [1:1:50]

// Add x holes
x_holes = false;

// --- Examples ---

// Example 1: Create a default support (uses default units and x_holes)
// support();

// Example 2: Create a support with 5 units and no x holes
// support(units=5, x_holes=false);

// Example 3: Create a support with units and x_holes as set above
support(units=units, x_holes=x_holes);

/* [Hidden] */
tolerance = 0.2;
printing_layer_width = 0.4;
printing_layer_height = 0.2;
base_unit = 15;
base_strength = 2;
base_chamfer = 1;
lockpin_hole_chamfer = 0.8;
lockpin_hole_side_length = 4;
lockpin_hole_side_length_dimension = [lockpin_hole_side_length, lockpin_hole_side_length];
HR_YELLOW = "#f7b600";
HR_BLUE = "#0056b3";
HR_RED = "#c41e3a";
HR_GREEN = "#2d7a2e";
HR_CHARCOAL = "#333333";
HR_WHITE = "#f0f0f0";

module support(units=3, x_holes=false) {
    support_dimensions = [base_unit, base_unit*units, base_unit];

    difference() {

        color("darkslategray")
        cuboid(support_dimensions, chamfer=base_chamfer);

        ycopies(spacing=base_unit, n=units) {

            color("red") lock_pin_hole();
        }
        if (x_holes) {
            ycopies(spacing=base_unit, n=units) {

                color("red") rotate([0,90,0]) lock_pin_hole();
            }
        }
    }
}

module lock_pin_hole() {
    lock_pin_center_side = lockpin_hole_side_length + printing_layer_width*2;
    lock_pin_center_dimension = [lock_pin_center_side, lock_pin_center_side];

    lock_pin_outer_side = lockpin_hole_side_length + lockpin_hole_chamfer*2;
    lock_pin_outer_dimension = [lock_pin_outer_side, lock_pin_outer_side];

    lock_pin_prismoid_inner_length = base_unit/2 - lockpin_hole_chamfer;
    lock_pin_prismoid_outer_length = lockpin_hole_chamfer;

    module hole_half() {
        union() {
            prismoid(size1=lock_pin_center_dimension, size2=lockpin_hole_side_length_dimension, h=lock_pin_prismoid_inner_length);
            translate([0, 0, lock_pin_prismoid_inner_length]) {
                prismoid(size1=lockpin_hole_side_length_dimension, size2=lock_pin_outer_dimension, h=lock_pin_prismoid_outer_length);
            }
        }
    }

    hole_half();

    mirror([0, 0, 1]) {
        hole_half();
    }
}

connector_outer_side_length = base_unit + base_strength*2 + tolerance;
arm_side_length_inner = connector_outer_side_length - base_strength*2;
core_to_arm_translation = base_unit;
CONNECTOR_CONFIGS = [

    [
        [true, false, false, false, false, false],
        [true, true, false, false, false, false]
    ],

    [
        [true, false, true, false, false, false],
        [true, true, true, false, false, false],
        [true, true, true, true, false, false]
    ],

    [
        [true, false, true, false, true, false],
        [true, true, true, false, true, false],
        [true, true, true, true, true, false],
        [true, true, true, true, true, true]
    ]
];
module connector(dimensions=3, directions=6, pull_through_axis="none", is_foot=false, optimal_orientation=false) {

  valid_dimensions = max(1, min(3, dimensions));

  min_directions = valid_dimensions == 1 ? 1 : valid_dimensions;
  max_directions = valid_dimensions * 2;

  valid_directions = max(min_directions, min(max_directions, directions));

  config = CONNECTOR_CONFIGS[valid_dimensions - 1][valid_directions - min_directions];

  difference() {

    union() {
      if (valid_directions > 4) {

        rotation_1 = optimal_orientation ? [-(180 - acos(1/sqrt(3))),0,0] : [0,0,0];
        rotation_2 = optimal_orientation ? [0,0,45] : [0,0,0];
        rotate(rotation_1) rotate(rotation_2)
        difference() {
          union() {
            connector_raw(config, is_foot);
            print_interface_3d();
          }
          pull_through_hole(pull_through_axis, is_foot);
        }
      } else if (valid_directions == 4 && valid_dimensions == 2) {
        rotation = optimal_orientation ? [0,-135,45] : [0,0,0];
        rotate(rotation)
        difference() {
          connector_raw(config, is_foot);
          pull_through_hole(pull_through_axis, is_foot);
        }

      } else {

        rotation = optimal_orientation ? [90,-45,-45] : [0,0,0];
        rotate(rotation)
        difference() {
          intersection() {
            connector_raw(config, is_foot);
            print_interface_base();
          }
          pull_through_hole(pull_through_axis, is_foot);
        }
      }
    }
  }
}

module connector_raw(config, is_foot=false) {
  difference() {

    union() {

      connectorCore();

      if (config[0]) translate([0, 0, core_to_arm_translation]) connectorArmOuter(is_foot);
      if (config[1]) translate([0, 0, -core_to_arm_translation]) rotate([180, 0, 0]) connectorArmOuter();
      if (config[2]) translate([core_to_arm_translation, 0, 0]) rotate([0, 90, 0]) connectorArmOuter();
      if (config[3]) translate([-core_to_arm_translation, 0, 0]) rotate([0, -90, 0]) connectorArmOuter();
      if (config[4]) translate([0, core_to_arm_translation, 0]) rotate([-90, 0, 0]) connectorArmOuter();
      if (config[5]) translate([0, -core_to_arm_translation, 0]) rotate([90, 0, 0]) connectorArmOuter();
    }

    if (config[0] && !is_foot) translate([0, 0, core_to_arm_translation]) connectorArmInner();
    if (config[1]) translate([0, 0, -core_to_arm_translation]) rotate([180, 0, 0]) connectorArmInner();
    if (config[2]) translate([core_to_arm_translation, 0, 0]) rotate([0, 90, 0]) connectorArmInner();
    if (config[3]) translate([-core_to_arm_translation, 0, 0]) rotate([0, -90, 0]) connectorArmInner();
    if (config[4]) translate([0, core_to_arm_translation, 0]) rotate([-90, 0, 0]) connectorArmInner();
    if (config[5]) translate([0, -core_to_arm_translation, 0]) rotate([90, 0, 0]) connectorArmInner();
  }
}

module connectorArmOuter(is_foot=false) {

  arm_dimensions_outer = [connector_outer_side_length, connector_outer_side_length, base_unit];
  arm_side_length_inner = connector_outer_side_length - base_strength*2;
  arm_dimensions_inner = [arm_side_length_inner, arm_side_length_inner, base_unit];

  difference() {
    color(HR_YELLOW) cuboid(arm_dimensions_outer, chamfer=base_chamfer,except=BOTTOM);
    if(!is_foot){
      color(HR_RED) rotate([90, 0, 0]) cuboid([lockpin_hole_side_length, lockpin_hole_side_length, connector_outer_side_length], chamfer=-lockpin_hole_chamfer);
      color(HR_RED) rotate([90, 0, 90]) cuboid([lockpin_hole_side_length, lockpin_hole_side_length, connector_outer_side_length], chamfer=-lockpin_hole_chamfer);
    }
  }
}

module connectorArmInner() {

  arm_dimensions_inner = [arm_side_length_inner, arm_side_length_inner, base_unit];
  color(HR_GREEN)
  cuboid(arm_dimensions_inner, chamfer=base_chamfer,edges=BOTTOM);
}

module connectorCore() {
  core_dimensions = [connector_outer_side_length, connector_outer_side_length, connector_outer_side_length];
  color(HR_BLUE)
  cuboid(core_dimensions, chamfer=base_chamfer);
}

module print_interface_3d() {

  side_length = base_unit - tolerance/2 - base_strength/2;

  translation = connector_outer_side_length/2 - base_chamfer;
  points = [
    [0, 0, 0],
    [side_length, 0, 0],
    [0, side_length, 0],
    [0, 0, side_length]
  ];

  faces = [
    [0, 2, 1],
    [0, 1, 3],
    [0, 3, 2],
    [1, 2, 3]
  ];

  color(HR_CHARCOAL)
  translate([translation, translation, translation])
  polyhedron(points=points, faces=faces, convexity=2);
}

module print_interface_base() {
  base_height = base_unit * 3;
  side_length = connector_outer_side_length *2;
  chamfer = base_chamfer * 3;

  color(HR_CHARCOAL)

  translate([connector_outer_side_length/2,connector_outer_side_length/2,0])
  cuboid([side_length, side_length, base_height], chamfer=chamfer, edges=LEFT+FRONT);
}

module pull_through_hole(axis="none", is_foot=false) {

  hole_length = base_unit * 3;
  hole_dimensions = [hole_length, arm_side_length_inner, arm_side_length_inner];

  color(HR_WHITE)
  if (axis == "y") {
    rotate([0, 0, 90])
    cuboid(hole_dimensions);
  } else if (axis == "z" && !is_foot) {
    rotate([0, -90, 0])
    cuboid(hole_dimensions);
  } else if (axis == "x") {
    cuboid(hole_dimensions);
  }
}

lockpin_chamfer = printing_layer_width;
lockpin_width_outer = lockpin_hole_side_length;
lockpin_width_inner = lockpin_hole_side_length + printing_layer_width * 2;
lockpin_height = lockpin_width_outer - tolerance;
lockpin_prismoid_length = (base_unit - base_strength) / 2;
lockpin_endpart_length = base_strength + base_strength / 2 + tolerance;
grip_width = lockpin_width_outer + base_strength*2;
grip_thickness_inner = printing_layer_width*2;
grip_thickness_outer = base_strength / 2;
grip_distance = base_strength / 2;
grip_base_length = grip_thickness_inner + grip_thickness_outer + grip_distance + lockpin_chamfer + tolerance/2;
module lockpin(grip_type = "standard") {
  rotate([90,0,0])
  difference() {

    union() {

      color(HR_YELLOW)
      tension_shape();

      end_parts(grip_type);

      color(HR_GREEN)
      grip(grip_type);
    }

    color(HR_RED)
    tension_hole();
  }
}

module grip(grip_type = "standard") {
  if (grip_type != "no_grip") {
    grip_base_dimensions = [lockpin_width_outer, lockpin_height, grip_base_length];
    grip_outer_dimensions = [grip_width, lockpin_height, grip_thickness_outer];
    grip_inner_dimensions = [grip_width, lockpin_height, grip_thickness_inner];

    base_translation = lockpin_prismoid_length + lockpin_endpart_length - lockpin_chamfer - tolerance/2;

    union() {

      translate([0, 0, -base_translation - grip_base_length / 2])
      cuboid(grip_base_dimensions, chamfer=lockpin_chamfer, except=TOP);

      if(grip_type == "standard") {
        translate([0, 0, -base_translation - grip_base_length + grip_thickness_outer / 2])
        cuboid(grip_outer_dimensions, chamfer=lockpin_chamfer, except=TOP);

        translate([0, 0, -base_translation - grip_base_length + grip_thickness_outer + grip_thickness_inner / 2 + grip_distance])
        cuboid(grip_inner_dimensions, chamfer=lockpin_chamfer, except=TOP);
      } else if (grip_type == "z_grip") {

        echo("Z-Grip variant not implemented yet.");
      }
    }
  }
}

module end_parts(grip_type = "standard") {
  end_part_half(true);
  mirror([0, 0, 1]) end_part_half(grip_type == "no_grip");
}

module end_part_half(front = false) {

  lockpin_fillet_front = lockpin_width_outer / 3;
  lockpin_endpart_dimension = [lockpin_width_outer, lockpin_height, lockpin_endpart_length];

  translate([0, 0, lockpin_prismoid_length + lockpin_endpart_length / 2 - tolerance/2])
  color(HR_BLUE)

  intersection() {
    cuboid(lockpin_endpart_dimension, rounding=front ? lockpin_fillet_front : 0, edges=[TOP + LEFT, TOP + RIGHT]);
    cuboid(lockpin_endpart_dimension, chamfer=lockpin_chamfer, edges=[FRONT,BACK], except=BOTTOM);
  }
}

module tension_shape() {
    tension_shape_half();
    mirror([0, 0, 1]) tension_shape_half();
}

module tension_shape_half() {
  lockpin_inner_dimension = [lockpin_width_inner, lockpin_height];
  lockpin_outer_dimension = [lockpin_width_outer, lockpin_height];
  lockpin_fillet_sides = base_unit;

  prismoid(lockpin_inner_dimension, lockpin_outer_dimension, height=lockpin_prismoid_length, chamfer=lockpin_chamfer);
}

module tension_hole(){
  tension_hole_half();
  mirror([0,0,1]) tension_hole_half();
}

module tension_hole_half(){
  lockpin_tension_angle = 86.5;
  lockpin_tension_hole_width_inner = printing_layer_width * 4;
  lockpin_tension_hole_height = base_unit / 2;
  lockpin_tension_hole_inner_dimension = [lockpin_tension_hole_width_inner, lockpin_height];
  prismoid(size1=lockpin_tension_hole_inner_dimension, height=lockpin_tension_hole_height, xang=lockpin_tension_angle, yang=90);
}

support(units=units, x_holes=x_holes);
