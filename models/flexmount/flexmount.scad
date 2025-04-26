// import BOSL2
include <BOSL2/std.scad>

$fn=100;

/* [Base] */
// If set to true, the mount will be fitted to align with the 10/19 inch HomRacker rackmount kit.
fit_to_rack=true;

/* [Device Measurements] */
// Width of the device in mm. Will determine how far apart the actual mounts are in width.
device_width=100
; // TODO test for zero cube
// Depth of the device in mm. Will determine how far apart the actual mounts are in depth.
device_depth=99;
// Height of the device in mm. Will determine how far apart the actual mounts are in height.
device_height=25.5;


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

// diff_width resembles the gap between the device and the mount. This gap will be filled with a cuboid
modulo_width=(BASE_UNIT - ( device_width + TOLERANCE ) % BASE_UNIT);
WIDTH_DIFF = modulo_width==15 ? 0 : modulo_width;
echo("Diff Width: ", WIDTH_DIFF);
mount_gap_filler_start=(device_width+TOLERANCE)/2;
echo("mount_gap_filler_start: ", mount_gap_filler_start);
echo("effective mount distance: ", device_width+WIDTH_DIFF+TOLERANCE);

// diff_depth resembles the 

/* Code */
// creates a bracket around the device with TOLERANCE as additional space and BASE_STRENGTH as the strength of the bracket
module bracket(width,depth,height) {
    // Bracket
    outer_width=width+BASE_STRENGTH*2;
    outer_depth=depth+BASE_STRENGTH*2;
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
            size=[width-BASE_STRENGTH*2,depth-BASE_STRENGTH*2,outer_height],
            anchor=BOTTOM,
            chamfer=-CHAMFER, edges=[TOP]
        );
        // Bottom Recess
        cuboid(
          size=[outer_width,outer_depth,height-BASE_STRENGTH],
          anchor=BOTTOM
        );     
      }
      translate([0,0,outer_height])
      cuboid(
        size=[outer_width,outer_depth,BASE_STRENGTH*2],
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

module mount_rail(width,depth,chamfer=CHAMFER) {
  difference(){
    height=BASE_UNIT+TOLERANCE/2;
    // outer
    cuboid(
      size=[width,depth,height],
      anchor=TOP+LEFT,
      chamfer=chamfer, edges=[FRONT,BACK], except=[TOP,LEFT]
    );
    // support recess
    cuboid(
      size=[width,BASE_UNIT+TOLERANCE,height],
      anchor=TOP+LEFT
    );
  }
}


// Mount
module mount(){
  depth=BASE_UNIT+BASE_STRENGTH*2+TOLERANCE;
  gap_filler_width=WIDTH_DIFF/2;
  union(){
   
    translate([mount_gap_filler_start,0,0])

    // Mount

    // Mirror the mount to create a symmetric mount
    
    

    union(){

      
      top_width=BASE_STRENGTH;
      bottom_width=BASE_UNIT+top_width+gap_filler_width;

      // Bridge
      difference(){
        cuboid_width = bottom_width-BASE_STRENGTH*2;
        cuboid_chamfer = device_height < cuboid_width ? device_height : cuboid_width;
        prismoid(
          size1 = [bottom_width, depth],  // Bottom face: width 30, depth 60
          size2 = [top_width, depth],   // Top face: becomes a line segment (width 0)
          shift = [(-bottom_width+top_width)/2, 0],   // Shift top edge center to X=+15 (aligns with right edge of base)
          chamfer=CHAMFER,
          h = device_height,             // Height
          //chamfer=CHAMFER/2,
          anchor = BOTTOM+LEFT // Anchor bottom left
        );
        translate([BASE_STRENGTH,0,BASE_STRENGTH])
        cuboid(
          size=[cuboid_width,BASE_UNIT,device_height],
          anchor=BOTTOM+LEFT,
          chamfer=cuboid_chamfer, edges=[LEFT], except=[TOP,RIGHT,FRONT,BACK]
        );
      }

      // Depth enforcement
      depth_enforcement_x = BASE_STRENGTH-TOLERANCE/2;
      prismoid(
        size1 = [depth_enforcement_x, depth],  
        size2 = [depth_enforcement_x, depth+BASE_UNIT],  
        h = device_height,             
        chamfer=[CHAMFER,0,0,CHAMFER],
        anchor = BOTTOM+LEFT 
      );
      
      // Mount Rail with holes
      difference(){
        mount_rail(bottom_width,depth);
        // holes
        translate([bottom_width-LOCK_PIN_EDGE_DISTANCE,0,-LOCK_PIN_EDGE_DISTANCE])
        cuboid(
          size=[LOCK_PIN_SIDE,depth,LOCK_PIN_SIDE],
          anchor=TOP+RIGHT
        );
      }
    }
      
  }
}

// Assembly
union() {
  
  difference() {
    bracket(device_width,device_depth,device_height);
    device(device_width,device_depth,device_height);
  }
  mount();
}


