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

// Example 1: Create a default support with 3 units
// support();

// Example 2: Create a support with 5 units
// support(units=5);

// Example 3: Create a taller support with 10 units
 support(units=units, x_holes=x_holes);
