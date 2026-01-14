// HomeRacker - Panel

// Use the main homeracker library file
include <../main.scad>

/* [Parameters] */

// Dimensions of the panel (X, Y; between 1-50)
x_dimension = 3; // [1:1:50]
y_dimension = 3; // [1:1:50]

// Ears of the panel (bits sticking out the top over the support) (none, half, full)
top_ear = "half"; // ["none","half","full"]
right_ear = "half"; // ["none","half","full"]
bottom_ear = "half"; // ["none","half","full"]
left_ear = "half"; // ["none","half","full"]

// Pattern of holes for the panel (hexgrid, none)
pattern = "hexgrid"; // ["hexgrid","none"]

/* [Hidden] */
$fn = 100;

dimensions = [x_dimension, y_dimension];
ears = [top_ear, right_ear, bottom_ear, left_ear];

// Color based on configuration:
// HR_GREEN - standard (half ears all sides)
// HR_YELLOW - full (full ears all sides)
// HR_BLUE - none (no ears)
// HR_RED - others (anything else)
function get_panel_color(ears=["half", "half", "half", "half"]) =
  ears[0] == "half" && ears[1] == "half" && ears[2] == "half" && ears[3] == "half" ? HR_RED :
  ears[0] == "full" && ears[1] == "full" && ears[2] == "full" && ears[3] == "full" ? HR_BLUE :
  ears[0] == "none" && ears[1] == "none" && ears[2] == "none" && ears[3] == "none" ? HR_YELLOW :
  HR_GREEN;

color(get_panel_color(ears=ears))
panel(dimensions=dimensions, ears=ears, pattern=pattern);
