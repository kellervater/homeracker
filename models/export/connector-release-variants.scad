// HomeRacker - Connector Release Variants
//
// This is an opinionated collection of useful connector variants for
// export and release. It includes standard connectors, footed connectors,
// pull-through connectors, and footed pull-through connectors as separate modules.

include <../homeracker.scad>

/* [Hidden] */
$fn = 100;
// Spacing between connectors (mm)
spacing = base_unit*3 + base_strength; // [20:5:40]

// Grid layout helper
module grid_position(row, col) {
    translate([col * spacing, row * spacing, 0])
        children();
}

module connectors_standard(optimal_orientation=false) {
  // Row 0: 1D variants
  grid_position(0, 0) connector(1, 2, "none", false, optimal_orientation);

  // Row 1: 2D variants
  grid_position(1, 0) connector(2, 2, "none", false, optimal_orientation);
  grid_position(1, 1) connector(2, 3, "none", false, optimal_orientation);
  grid_position(1, 2) connector(2, 4, "none", false, optimal_orientation);

  // Row 2: 3D variants
  grid_position(2, 0) connector(3, 3, "none", false, optimal_orientation);
  grid_position(2, 1) connector(3, 4, "none", false, optimal_orientation);
  grid_position(2, 2) connector(3, 5, "none", false, optimal_orientation);
  grid_position(2, 3) connector(3, 6, "none", false, optimal_orientation);
}

module connectors_feet(optimal_orientation=false) {

  // Row 0: 2D foot variants
  grid_position(0, 0) connector(2, 2, "none", true, optimal_orientation);
  grid_position(0, 1) connector(2, 3, "none", true, optimal_orientation);
  grid_position(0, 2) connector(2, 4, "none", true, optimal_orientation);

  // Row 1: 3D foot variants
  grid_position(1, 0) connector(3, 3, "none", true, optimal_orientation);
  grid_position(1, 1) connector(3, 4, "none", true, optimal_orientation);
  grid_position(1, 2) connector(3, 5, "none", true, optimal_orientation);
  grid_position(1, 3) connector(3, 6, "none", true, optimal_orientation);
}

module connectors_pull_through(optimal_orientation=false) {
  // Row 0: 1D pull-through variants
  grid_position(0, 0) connector(1, 1, "x", false, optimal_orientation);
  grid_position(0, 1) connector(1, 2, "x", false, optimal_orientation);

  // Row 1: 2D pull-through variants
  grid_position(1, 0) connector(2, 2, "x", false, optimal_orientation);
  grid_position(1, 1) connector(2, 2, "y", false, optimal_orientation);
  grid_position(1, 2) connector(2, 3, "x", false, optimal_orientation);
  grid_position(1, 3) connector(2, 3, "y", false, optimal_orientation);
  grid_position(1, 4) connector(2, 3, "z", false, optimal_orientation);
  grid_position(1, 5) connector(2, 4, "x", false, optimal_orientation);
  grid_position(1, 6) connector(2, 4, "y", false, optimal_orientation);

  // Row 2: 3D pull-through variants
  grid_position(2, 0) connector(3, 3, "x", false, optimal_orientation);
  grid_position(2, 1) connector(3, 4, "x", false, optimal_orientation);
  grid_position(2, 2) connector(3, 4, "z", false, optimal_orientation);
  grid_position(2, 3) connector(3, 5, "x", false, optimal_orientation);
  grid_position(2, 4) connector(3, 5, "y", false, optimal_orientation);
  grid_position(2, 5) connector(3, 6, "x", false, optimal_orientation);
}

module connectors_pull_through_feet(optimal_orientation=false) {

  // Row 0: 2D foot pull-through variants
  grid_position(0, 0) connector(2, 2, "x", true, optimal_orientation);
  grid_position(0, 1) connector(2, 2, "y", true, optimal_orientation);
  grid_position(0, 2) connector(2, 3, "x", true, optimal_orientation);
  grid_position(0, 3) connector(2, 3, "y", true, optimal_orientation);
  grid_position(0, 4) connector(2, 4, "x", true, optimal_orientation);
  grid_position(0, 5) connector(2, 4, "y", true, optimal_orientation);

  // Row 1: 3D foot pull-through variants
  grid_position(1, 0) connector(3, 3, "x", true, optimal_orientation);
  grid_position(1, 1) connector(3, 4, "x", true, optimal_orientation);
  grid_position(1, 2) connector(3, 5, "x", true, optimal_orientation);
  grid_position(1, 3) connector(3, 5, "y", true, optimal_orientation);
  grid_position(1, 4) connector(3, 6, "x", true, optimal_orientation);
}


// Create grid of all standard connectors
// connectors_standard(true);
// connectors_feet(true);
// connectors_pull_through(true);
// connectors_pull_through_feet(true);
