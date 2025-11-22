// HomeRacker - Lock Pin
//
// Fully customizable lock pin part.

// Use the main homeracker library file
include <../main.scad>

/* [Parameters] */

// Type of grip for the lock pin
grip_type = "standard"; // ["standard","no_grip"]

// --- Examples ---

// Example 1: Create a default lock pin (uses default grip_type)
// lockpin();

// Example 2: Create a lock pin with no grip
// lockpin(grip_type="no_grip");

// Example 3: Create a lock pin with grip_type as set above
color(HR_YELLOW)
lockpin(grip_type=grip_type);
