// HomeRacker - Lock Pin Release Variants
//
// This is an opinionated collection of useful lock pin variants for
// export and release. Creates a grid pattern of lock pins for efficient printing.

include <../main.scad>

/* [General] */
grid = 5; // Total number of lock pins to create

/* [Hidden] */
$fn = 100;

// Grid configuration
spacing = [ grip_width + printing_layer_width * 2, base_unit + base_strength * 2 + tolerance + printing_layer_width  * 2 + grip_base_length];

module lockpins_grid(grid=10, grip_type="standard") {
    grid_copies(spacing, n=grid) {
        color(HR_YELLOW)
        lockpin(grip_type=grip_type);
    }
}

// Standard grip grid (50 pins)
// lockpins_grid(grid=grid, grip_type="standard");

// Uncomment for no-grip variant:
lockpins_grid(grid=grid, grip_type="no_grip");
