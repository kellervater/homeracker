// import BOSL2
include <BOSL2/std.scad>

/* [Hidden] */
// constants which shouldn't be changed
$fn=100;

// This is the HomeRacker base unit. don't change this!
BASE_UNIT=15; // mm
// Standard tolerance for the mount. This is a sane default.
TOLERANCE=0.2; // mm
// Base strength. This is a sane default.
BASE_STRENGTH=2; // mm
// Chamfer size. This is a sane default.
CHAMFER=2.5; // mm
// Lock Pin side length
LOCK_PIN_SIDE=3; // mm
// lock pin edge distance
LOCK_PIN_EDGE_DISTANCE=5.5; // mm
// lock pin chamfer
LOCK_PIN_CHAMFER=0.8; // mm

GRIDFINITY_BASEPLATE_SIDE_LENGTH=42; // mm
GRIDFINITY_BASEPLATE_STRENGTH=8; // mm
GRIDFINITY_BASEPLATE_SIDE_LENGTH_INNER=GRIDFINITY_BASEPLATE_SIDE_LENGTH-GRIDFINITY_BASEPLATE_STRENGTH/2; // mm

GRIDFINITY_INCLINE_1=0.7; // mm
GRIDFINITY_INCLINE_2=1.8; // mm
GRIDFINITY_INCLINE_3=2.15; // mm
GRIDFINITY_BASEPLATE_HEIGHT=GRIDFINITY_INCLINE_1+GRIDFINITY_INCLINE_2+GRIDFINITY_INCLINE_3; // mm

/* [Grdifinity] */
x_units=1; // [1:1:10]
y_units=1; // [1:1:10]

module recess(side_length,chamfer){
  //chamfer
  rotate([180,0,0])
  prismoid(
    size1=[side_length,side_length], 
    rounding=chamfer, 
    h=chamfer,
    xang=45,
    yang=45
    ); 
}

module gridfinity_unit(){
  difference(){
    //outer cube
    cuboid(
        size=[GRIDFINITY_BASEPLATE_SIDE_LENGTH,GRIDFINITY_BASEPLATE_SIDE_LENGTH,GRIDFINITY_BASEPLATE_HEIGHT],
        anchor=CENTER+BOTTOM
    );
    //1st recess
    
    translate([0,0,GRIDFINITY_BASEPLATE_HEIGHT])
    recess(
      GRIDFINITY_BASEPLATE_SIDE_LENGTH,
      GRIDFINITY_INCLINE_3);
    //2nd recess
    translate([0,0,GRIDFINITY_BASEPLATE_HEIGHT-GRIDFINITY_INCLINE_3-GRIDFINITY_INCLINE_2])
    cuboid(
      size=[
        GRIDFINITY_BASEPLATE_SIDE_LENGTH-GRIDFINITY_INCLINE_3*2,
        GRIDFINITY_BASEPLATE_SIDE_LENGTH-GRIDFINITY_INCLINE_3*2,
        GRIDFINITY_INCLINE_2
        ],
      rounding=GRIDFINITY_INCLINE_2,
      except=[BOTTOM,TOP],
      anchor=CENTER+BOTTOM
    );
    // //3rd recess
    translate([0,0,GRIDFINITY_INCLINE_1+0.01])
    recess(
      GRIDFINITY_BASEPLATE_SIDE_LENGTH_INNER,
      GRIDFINITY_INCLINE_1+0.01
    );
  }
}

module grid(x,y){
  intersection(){
    grid_copies(spacing=[GRIDFINITY_BASEPLATE_SIDE_LENGTH,GRIDFINITY_BASEPLATE_SIDE_LENGTH],n=[x,y])
    gridfinity_unit();
    // roundings
    cuboid(
      size=[GRIDFINITY_BASEPLATE_SIDE_LENGTH*x,GRIDFINITY_BASEPLATE_SIDE_LENGTH*y,GRIDFINITY_BASEPLATE_HEIGHT*2],
      anchor=CENTER+BOTTOM,
      rounding=CHAMFER,
      except=[BOTTOM,TOP]
    );
  }
  
}


grid(x=2,y=3);