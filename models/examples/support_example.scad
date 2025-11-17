// HomeRacker - Support Example
//
// This file demonstrates how to use the support module from the HomeRacker library.

// Use the main homeracker library file
include <../homeracker.scad>

/* [Parameters] */

// The length (Y-axis) of the support in base units.
units = 3; // [1:1:50]

// Add x holes
x_holes = false;

// --- Examples ---

// Example 1: Create a default support (uses default units and x_holes)
// support();

// Example 2: Create a support with 5 units and no x holes
// support(units=5, x_holes=false);

// Example 3: Create a support with units and x_holes as set above
support(units=units, x_holes=x_holes);
