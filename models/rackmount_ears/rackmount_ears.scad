// import BOSL2
include <BOSL2/std.scad>

$fn=100;

/* [Base] */
// automatically chooses the tightest fit for the rackmount ears based on the device width. If true, rack_size will be ignored.
autosize=true;
// rack size in inches. If autosize is true, this value will be ignored. Only 10 and 19 inch racks are supported.
rack_size=10; // [10:10 inch,19:19 inch]

// Width of the device in mm. Will determine the width of the rackmount ears depending on rack_size. 
device_width=201;
// Height of the device in mm. Will determine the height of the rackmount ear in standard HeightUnits (1HU=44.5 mm). The program will always choose the minimum number of units to fit the device height. Minimum is 1 unit.
device_height=40;
// Thickness of the rackmount ear.
strength=3; 

/* [Device Bores] */
// Distance (in mm) of the device's front bores(s) to the front of the device
device_bore_distance_front=9.5;
// Distance (in mm) of the device's bottom bore(s) to the bottom of the device
device_bore_distance_bottom=9.5;
// distance between the bores in the horizontal direction
device_bore_margin_horizontal=25;
// distance between the bores in the vertical direction
device_bore_margin_vertical=25;
// diameter of the bore (should be at least the same as the diameter of the screw shaft)
device_bore_hole_diameter=3.3;
// diameter of the bore head (if not countersunk, just choose the same as device_bore_hole_diameter)
device_bore_hole_head_diameter=6;
// How long is the screw head in depth. This determines the angle of the countersink. The longer the screw head, the more the countersink is inclined.
device_bore_hole_head_length=1.2;
// number of bores in the horizontal direction (will be multiplied by device_bore_rows)
device_bore_columns=2;
// number of bores in the vertical direction (will be multiplied by device_bore_columns)
device_bore_rows=2;
// If true, the device will be aligned to the center of the rackmount ear. Otherwise it will be aligned to the bottom of the rackmount ear.
center_device_bore_alignment=false;


/* [CONSTANTS (shouldn't need to be changed)] */
CAGE_BOLT_DIAMETER=6.5;
CHAMFER=min(strength/3,0.5);
RACK_BORE_DISTANCE_VERTICAL=15.875;
RACK_BORE_DISTANCE_TOP_BOTTOM=6.35;
RACK_MOUNT_SURFACE_WIDTH=15.875;
RACK_BORE_DISTANCE_HORIZONTAL=RACK_MOUNT_SURFACE_WIDTH/2;
RACK_BORE_WIDTH=RACK_MOUNT_SURFACE_WIDTH-2*max(strength,2);
RACK_HEIGHT_UNIT=44.5; // mm
RACK_HEIGHT_UNIT_COUNT=max(1,ceil(device_height/RACK_HEIGHT_UNIT));
RACK_HEIGHT=RACK_HEIGHT_UNIT_COUNT*RACK_HEIGHT_UNIT; // actual height calculated by height unit size x number of units
RACK_BORE_COUNT=RACK_HEIGHT_UNIT_COUNT*3; // 3 holes for each units
RACK_WIDTH_10_INCH_INNER=222.25; // mm
RACK_WIDTH_10_INCH_OUTER=254; // mm
RACK_WIDTH_19_INCH=482.6; // mm

// Base assertions
module validate_params() {
    valid_rack_sizes=[10,19];
    if(autosize == false){
        assert(rack_size == 10 || rack_size == 19, "Invalid rack_size. Only 10 and 19 inch racks are supported. Choose a valid one or set autosize to true.");
    }
}

validate_params();

// Debug
echo("Height: ", RACK_HEIGHT);
echo("Rack Bore Count: ", RACK_BORE_COUNT);

// Calculate the width of the ear
function get_ear_width(device_width) = 
    device_width > RACK_WIDTH_10_INCH_INNER || autosize == false && rack_size == 19 ?   
        (RACK_WIDTH_19_INCH - device_width) / 2 :  
        (RACK_WIDTH_10_INCH_OUTER - device_width) / 2
;
rack_ear_width = get_ear_width(device_width);

function get_bore_depth(device_bore_margin_horizontal,device_bore_columns) =
    (device_bore_columns - 1) * device_bore_margin_horizontal
;
// Calculate the depth of the ear
depth=device_bore_distance_front*2+get_bore_depth(device_bore_margin_horizontal,device_bore_columns);
device_screw_alignment_vertical=
    center_device_bore_alignment ? 
        RACK_HEIGHT / 2 : 
        device_bore_margin_vertical / 2 + device_bore_distance_bottom
;
device_screw_alignment = [strength,depth/2,device_screw_alignment_vertical];

module base_ear(width,strength,height) {
    union() {
        // Front face
        cuboid([rack_ear_width,strength,height],anchor=LEFT+BOTTOM+FRONT,chamfer=CHAMFER);
        // Side face
        cuboid([strength,depth,height],anchor=LEFT+BOTTOM+FRONT,chamfer=CHAMFER);
    }
}

module screws_countersunk(length, diameter_head, length_head, diameter_shaft) {
    translate(device_screw_alignment) 
    yrot(-90) 
    grid_copies(spacing=[device_bore_margin_vertical,device_bore_margin_horizontal],n=[device_bore_rows, device_bore_columns])
    union() {
        cylinder(h=length_head, r1=diameter_head/2, r2=diameter_shaft/2);
        translate([0,0,length_head]) cylinder(h=length-length_head, r=diameter_shaft/2);
    }
}


// Assemble the rackmount ear
difference() {
    difference() {
        // Create the base of the ear
        base_ear(device_width,strength,RACK_HEIGHT);
        // Create the holes for the device screws
        screws_countersunk(length=strength,diameter_head=device_bore_hole_head_diameter,length_head=device_bore_hole_head_length,diameter_shaft=device_bore_hole_diameter);
    }
    // Create the holes for the rackmount screws
    zcopies(spacing=RACK_HEIGHT_UNIT,n=RACK_HEIGHT_UNIT_COUNT,sp=[0,0,0])
    zcopies(spacing=RACK_BORE_DISTANCE_VERTICAL,n=3,sp=[rack_ear_width-RACK_BORE_DISTANCE_HORIZONTAL,0,RACK_BORE_DISTANCE_TOP_BOTTOM])
    cuboid([RACK_BORE_WIDTH,strength+1,CAGE_BOLT_DIAMETER], rounding=CAGE_BOLT_DIAMETER/2, edges=[TOP+LEFT,TOP+RIGHT,BOTTOM+LEFT,BOTTOM+RIGHT], anchor=FRONT);
}
