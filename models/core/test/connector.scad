// HomeRacker - Connector Example
//
// This file demonstrates how to use the connector module from the HomeRacker library.

// Use the main homeracker library file
include <../main.scad>

dimensions = 3;
directions = 6;
pull_through_axis = "x";
is_foot = true;
optimal_orientation = true;

connector(dimensions, directions, pull_through_axis, is_foot, optimal_orientation);
