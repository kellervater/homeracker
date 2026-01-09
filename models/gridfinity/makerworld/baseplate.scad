include <BOSL2/std.scad>

/* [Parameters] */
// x dimensions (in multiples of 42mm)
grid_x = 1; // [1:1:10]
// y dimensions (in multiples of 42mm)
grid_y = 2; // [1:1:10]

/* [Hidden] */
// Optimized for 0.4mm nozzle 3D printing (allegedly according to Sonnet 4.5's research)
// Preview: Faster but still smooth
// Render: Based on typical 0.4mm nozzle capabilities
TOLERANCE = 0.2;
PRINTING_LAYER_WIDTH = 0.4;
PRINTING_LAYER_HEIGHT = 0.2;
BASE_UNIT = 15;
BASE_STRENGTH = 2;
BASE_CHAMFER = 1;
LOCKPIN_HOLE_CHAMFER = 0.8;
LOCKPIN_HOLE_SIDE_LENGTH = 4;
LOCKPIN_HOLE_SIDE_LENGTH_DIMENSION = [LOCKPIN_HOLE_SIDE_LENGTH, LOCKPIN_HOLE_SIDE_LENGTH];
HR_YELLOW = "#f7b600";
HR_BLUE = "#0056b3";
HR_RED = "#c41e3a";
HR_GREEN = "#2d7a2e";
HR_CHARCOAL = "#333333";
HR_WHITE = "#f0f0f0";
STD_UNIT_HEIGHT = 44.45;
STD_UNIT_DEPTH = 482.6;
STD_WIDTH_10INCH = 254;
STD_WIDTH_19INCH = 482.6;
STD_MOUNT_SURFACE_WIDTH = 15.875;
STD_RACK_BORE_DISTANCE_Z = 15.875;
STD_RACK_BORE_DISTANCE_MARGIN_Z = 6.35;
tolerance = TOLERANCE;
printing_layer_width = PRINTING_LAYER_WIDTH;
printing_layer_height = PRINTING_LAYER_HEIGHT;
base_unit = BASE_UNIT;
base_strength = BASE_STRENGTH;
base_chamfer = BASE_CHAMFER;
lockpin_hole_chamfer = LOCKPIN_HOLE_CHAMFER;
lockpin_hole_side_length = LOCKPIN_HOLE_SIDE_LENGTH;
lockpin_hole_side_length_dimension = LOCKPIN_HOLE_SIDE_LENGTH_DIMENSION;

BOTTOM_LIP_SIDE_LENGTH = 36.3;
BOTTOM_LIP_ROUNDING = 1.15;
BOTTOM_LIP_HEIGHT = 0.7;
MID_PART_SIDE_LENGTH = 37.7;
MID_PART_ROUNDING = 1.85;
MID_PART_HEIGHT = 1.8;
TOP_PART_SIDE_LENGTH = 42;
TOP_PART_ROUNDING = 4;
TOP_PART_HEIGHT = 2.15;
module baseplate_cutout() {
  prismoid(BOTTOM_LIP_SIDE_LENGTH, MID_PART_SIDE_LENGTH, rounding1=BOTTOM_LIP_ROUNDING, rounding2=MID_PART_ROUNDING, h=BOTTOM_LIP_HEIGHT)
    attach(TOP,BOTTOM) cuboid([MID_PART_SIDE_LENGTH, MID_PART_SIDE_LENGTH, MID_PART_HEIGHT], rounding=MID_PART_ROUNDING, except=[BOTTOM,TOP])
    attach(TOP,BOTTOM) prismoid(MID_PART_SIDE_LENGTH, TOP_PART_SIDE_LENGTH, rounding1=MID_PART_ROUNDING, rounding2=TOP_PART_ROUNDING, h=TOP_PART_HEIGHT);
}

module baseplate(units_x=1, units_y=1) {
  assert(is_int(units_x), "units_x must be an integer");
  assert(is_int(units_y), "units_y must be an integer");
  assert(units_x >= 1, "units_x must be at least 1");
  assert(units_y >= 1, "units_y must be at least 1");

  BASEPLATE_HEIGHT = BOTTOM_LIP_HEIGHT+MID_PART_HEIGHT+TOP_PART_HEIGHT-PRINTING_LAYER_HEIGHT*3;
  baseplate_dimensions = [TOP_PART_SIDE_LENGTH*units_x, TOP_PART_SIDE_LENGTH*units_y, BASEPLATE_HEIGHT];

  difference() {

    cuboid(baseplate_dimensions, rounding=TOP_PART_ROUNDING, except=[TOP,BOTTOM], anchor=BOTTOM);

    grid_copies(n=[units_x, units_y], spacing=TOP_PART_SIDE_LENGTH)
      baseplate_cutout();
  }
}

color(HR_YELLOW)
baseplate(grid_x, grid_y);

$fs = $preview ? 0.8 : 0.4;
$fa = $preview ? 6 : 2;
color(HR_YELLOW)
baseplate(grid_x, grid_y);
