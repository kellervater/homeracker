// HomeRacker - Connector Example
//
// This file demonstrates how to use the connector module from the HomeRacker library.

// Use the main homeracker library file
include <../main.scad>

/* [Parameters] */

// Dimensions of the connector (between 1-3)
dimensions = 3; // [1:1:3]

// Directions of the connector (between 1-6)
directions = 3; // [1:1:6]

// Pull-through axis (none, x,y,z)
pull_through_axis = "none"; // ["none","x","y","z"]

// Is-Foot. Might clash with pull-through axis when set to "z". is_foot has priority then.
is_foot = false; // [true,false]

// Optimal Printing Orientation
optimal_orientation = true; // [true,false]

/* [Hidden] */
$fn = 100;

// Color based on configuration:
// HR_GREEN - standard (no pull through, no foot)
// HR_YELLOW - pull-through (x/y/z pull through, no foot)
// HR_BLUE - foot (no pull through, has foot)
// HR_RED - pull-through foot (pull through and foot)
function get_connector_color(pull_through_axis="none", is_foot=false) =
  is_foot && pull_through_axis != "none" ? HR_RED :
  is_foot ? HR_BLUE :
  pull_through_axis != "none" ? HR_YELLOW :
  HR_GREEN;

color(get_connector_color(pull_through_axis, is_foot))
connector(dimensions, directions, pull_through_axis, is_foot, optimal_orientation);
