// import BOSL2
include <BOSL2/std.scad>

$fn=100;

/* [Hidden] */
// constants which shouldn't be changed

// This is the HomeRacker base unit. don't change this!
BASE_UNIT=15; // mm
// Standard tolerance for the mount. This is a sane default.
TOLERANCE=0.2; // mm
// Base strength. This is a sane default.
BASE_STRENGTH=2; // mm
// Chamfer size. This is a sane default.
CHAMFER=1; // mm
// Lock Pin side length
LOCK_PIN_SIDE=4; // mm
// lock pin edge distance
LOCK_PIN_EDGE_DISTANCE=5.5; // mm

/* [Base] */
// If set to true, the mount will be fitted to align with the 10/19 inch HomRacker rackmount kit.
//fit_to_rack=true;

/* [Device Measurements] */
// Width of the device in mm. Will determine how far apart the actual mounts are in width.
device_width=104.8 // [20:0.1:500]
; // TODO test for zero cube
// Depth of the device in mm. Will determine how far apart the actual mounts are in depth.
device_depth=105; // [54:0.1:500]
// Height of the device in mm. Will determine how far apart the actual mounts are in height.
device_height=25.5; // [15:0.1:500]

/* [Bracket] */
// Defines the bracket thickness on top of the device.
bracket_strength_top=7.5; // [4:0.1:20]
bracket_strength_sides=7.5; // [4:0.1:20]

// diff_width resembles the gap between the device and the mount. This gap will be filled with a cuboid
modulo_width=(BASE_UNIT - ( device_width + TOLERANCE ) % BASE_UNIT);
WIDTH_DIFF = modulo_width==15 ? 0 : modulo_width;
echo("Diff Width: ", WIDTH_DIFF);
mount_gap_filler_start=(device_width+TOLERANCE)/2;
// echo("mount_gap_filler_start: ", mount_gap_filler_start);
// echo("effective mount distance: ", device_width+WIDTH_DIFF+TOLERANCE);


DEPTH_DIFF=device_depth % BASE_UNIT;
echo("Diff Depth: ", DEPTH_DIFF);
mount_offset_depth=(device_depth-DEPTH_DIFF-BASE_UNIT)/2;
echo("mount_offset_depth*2: ", mount_offset_depth*2);

/* Code */
// creates a bracket around the device with TOLERANCE as additional space and BASE_STRENGTH as the strength of the bracket
module bracket(width,depth,height) {
    // Bracket
    outer_width=width+BASE_STRENGTH*2+TOLERANCE;
    outer_depth=depth+BASE_STRENGTH*2+TOLERANCE;
    outer_height=height+BASE_STRENGTH;
    intersection(){
      difference() {
        // Outer
        cuboid(
            size=[outer_width,outer_depth,outer_height],
            anchor=BOTTOM,
            chamfer=CHAMFER, edges=[TOP,FRONT,BACK,LEFT,RIGHT], except=[BOTTOM]
        );
        // Top Skeleton
        cuboid(
            size=[width-bracket_strength_top,depth-bracket_strength_top,outer_height],
            anchor=BOTTOM,
            chamfer=-CHAMFER, edges=[TOP]
        );
        // Bottom Recess
        cuboid(
          size=[outer_width,outer_depth,height-bracket_strength_sides],
          anchor=BOTTOM
        );     
      }
      translate([0,0,outer_height])
      cuboid(
        size=[outer_width,outer_depth,bracket_strength_sides],
        anchor=TOP,
        chamfer=CHAMFER, edges=[BOTTOM]
      );  
    }
}

// device module adds TOLERANCE to the device size and creates a cuboid with the device size
// this is used to create the device in the mount and add TOLERANCE to the device size for spacing
module device(width,depth,height) {
    // Device
    cuboid(
        size=[width+TOLERANCE,depth+TOLERANCE,height+TOLERANCE],
        anchor=BOTTOM
    );
}

// Mount
module mount(){
  depth=BASE_UNIT+BASE_STRENGTH*2+TOLERANCE;
  gap_filler_width=(WIDTH_DIFF)/2;

  // depth translation
  translate([0,mount_offset_depth,0])

  union(){
   
    translate([mount_gap_filler_start,0,0])
    // Mount
    union(){      
      top_width=BASE_STRENGTH;
      bottom_width=BASE_UNIT+gap_filler_width;
      // Bridge
      difference(){
        cuboid_width = bottom_width;
        cuboid_chamfer = bottom_width;
        prismoid(
          size1 = [bottom_width, depth],  // Bottom face: width 30, depth 60
          size2 = [top_width, depth],   // Top face: becomes a line segment (width 0)
          shift = [(-bottom_width+top_width)/2, 0],   // Shift top edge center to X=+15 (aligns with right edge of base)
          chamfer=CHAMFER,
          h = device_height,             // Height
          //chamfer=CHAMFER/2,
          anchor = BOTTOM+LEFT // Anchor bottom left
        );
        translate([0,0,BASE_STRENGTH])
        cuboid(
          size=[cuboid_width,BASE_UNIT,device_height],
          anchor=BOTTOM+LEFT,
          chamfer=BASE_UNIT/2, edges=[BOTTOM], except=[RIGHT]
        );
      }

      // Depth enforcement
      depth_enforcement_x = BASE_STRENGTH;
      depth_enforcemnt_y2 = BASE_UNIT*2;
      prismoid(
        size1 = [depth_enforcement_x, depth],  
        size2 = [depth_enforcement_x, depth_enforcemnt_y2],
        shift = [0, (depth-depth_enforcemnt_y2)/2], 
        h = device_height,             
        chamfer=[CHAMFER,0,0,CHAMFER],
        anchor = BOTTOM+LEFT 
      );
      
      // Mount Rail with holes
      difference(){
        // Mount Rail
        difference(){
          height=BASE_UNIT+TOLERANCE/2;
          // outer
          cuboid(
            size=[bottom_width,depth,height],
            anchor=TOP+LEFT,
            chamfer=CHAMFER, edges=[BOTTOM,RIGHT], except=[TOP]
          );
          // support recess
          cuboid(
            size=[bottom_width,BASE_UNIT+TOLERANCE,height],
            anchor=TOP+LEFT
          );
        }
        // holes
        translate([bottom_width-LOCK_PIN_EDGE_DISTANCE,0,-LOCK_PIN_EDGE_DISTANCE-TOLERANCE/2])
        cuboid(
          size=[LOCK_PIN_SIDE,depth,LOCK_PIN_SIDE],
          anchor=TOP+RIGHT
        );
      }
    }
  }
}


module mirror_mount_x_plane(){
  mount();
  x_mirror_plane = [1,0,0];
  mirror(x_mirror_plane) {
    mount();
  }
}

// Assembly
rotate([180,0,0])
union() {
  
  
  difference() {
    bracket(device_width,device_depth,device_height);
    device(device_width,device_depth,device_height);
  }
  // Mount Right
  mirror_mount_x_plane();

  y_mirror_plane = [0,1,0];
  mirror(y_mirror_plane) {
    mirror_mount_x_plane();
  }
  
}


