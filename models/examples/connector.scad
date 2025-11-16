// HomeRacker - Support Example
//
// This file demonstrates how to use the support module from the HomeRacker library.

// Use the main homeracker library file
include <../homeracker.scad>

/* [Parameters] */

// Dimensions of the connector (between 1-3)
dimensions = 3; // [1:1:3]

// Directions of the connector (between 1-6)
directions = 3; // [1:1:6]

// Pull-through axis (none, x,y,z)
pull_through_axis = "none"; // ["none","x","y","z"]

// Is-Foot. Might clash with pull-through axis when set to "z". is_foot has priority then.
is_foot = false; // [true,false]

/* [Hidden] */
$fn = 100;

connector(dimensions, directions, pull_through_axis, is_foot);
