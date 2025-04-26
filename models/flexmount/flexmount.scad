// import BOSL2
include <BOSL2/std.scad>

$fn=100;

/* [Base] */
// If set to true, the mount will be fitted to align with the 10/19 inch HomRacker rackmount kit.
fit_to_rack=true;

/* [Device Measurements] */
// Width of the device in mm. Will determine how far apart the actual mounts are in width.
device_width=100; // TODO test for zero cube
// Depth of the device in mm. Will determine how far apart the actual mounts are in depth.
device_depth=99.0;
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

// diff_width resembles the gap between the device and the mount. This gap will be filled with a cuboid
width_diff=( device_width + TOLERANCE ) % BASE_UNIT / 2;
echo("Diff Width: ", width_diff);
mount_anchor_left=device_width/2 + width_diff;
echo("mount_anchor_left: ", mount_anchor_left);
mount_gap_filler_start=(device_width+TOLERANCE)/2;
echo("mount_gap_filler_start: ", mount_gap_filler_start);
echo("mount_gap_filler_width: ", mount_anchor_left-mount_gap_filler_start);
echo("effective mount distance: ", device_width+width_diff*2);

/* Code */
// creates a bracket around the device with TOLERANCE as additional space and BASE_STRENGTH as the strength of the bracket
module bracket(width,depth,height) {
    // Bracket
    difference() {
        // Outer
        cuboid(
            size=[width+BASE_STRENGTH,depth+BASE_STRENGTH,height+BASE_STRENGTH],
            anchor=BOTTOM,
            chamfer=CHAMFER, edges=[TOP,FRONT,BACK,LEFT,RIGHT], except=[BOTTOM]
        );
        // Top Skeleton
        cuboid(
            size=[width-BASE_STRENGTH*2,depth-BASE_STRENGTH*2,height+BASE_STRENGTH],
            anchor=BOTTOM,
            chamfer=-CHAMFER, edges=[TOP]
        );
        // Bottom Recess
        cuboid(
          size=[width+BASE_STRENGTH,depth+BASE_STRENGTH,height-BASE_STRENGTH],
          anchor=BOTTOM
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

module mount_rail(width,depth) {
  difference(){
    height=BASE_UNIT+TOLERANCE/2;
    // outer
    cuboid(
      size=[width,depth,height],
      anchor=TOP+LEFT
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
  union(){
    translate([mount_gap_filler_start,0,0])
    // Gap Filler
    union(){
      cuboid(
        size=[width_diff,depth,device_height+BASE_STRENGTH],
        anchor=BOTTOM+LEFT
      );
      mount_rail(width_diff,depth);
    }
    
    translate([mount_gap_filler_start+width_diff,0,0])

    // Mount
    union(){
      // Bridge
      prismoid(
        size1 = [BASE_UNIT, depth],  // Bottom face: width 30, depth 60
        size2 = [0, depth],   // Top face: becomes a line segment (width 0)
        shift = [-BASE_UNIT/2, 0],   // Shift top edge center to X=+15 (aligns with right edge of base)
        h = device_height+BASE_STRENGTH,             // Height
        anchor = BOTTOM+LEFT // Anchor bottom left
      );
      // Mount Rail
      mount_rail(BASE_UNIT,depth);
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


