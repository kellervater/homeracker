height = 3.791;
length = 22.1;
width = 4.0;
taper = 0.743;
taperPosition = 0.57;
taperLength = 0.62;
wall = 1.6;
gripWidth = 8.0;
booleanOffset = 0.1;

pin();

module pin () {
    difference() {
        union() {
            mainBody();
            grip();
        };
        linear_extrude(height = height + 2 * booleanOffset) {
            translate([0, 0, -booleanOffset]) {
                cutout();
            };
        };
    };
};

module mainBody() {
    chamfer = 0.5;

    difference() {
        linear_extrude(height = height) {
            symmetry() {
                polygon([
                    [0, width / 2],
                    [length * (taperPosition - taperLength / 2.0), width / 2],
                    [length * taperPosition, (width + taper) / 2],
                    [length * (taperPosition + taperLength / 2.0), width / 2],
                    [length - chamfer, 2],
                    [length, 2 - chamfer],
                    [length, 0],
                    [0, 0],
                ]);
            };
        };

        union() {
            rotate([90, 0, 0]) {
                linear_extrude(height = gripWidth + booleanOffset, center = true) {
                    polygon([
                        [-booleanOffset, height + booleanOffset],
                        [chamfer, height],
                        [0, height - chamfer],
                    ]);
                    polygon([
                        [length, height - chamfer],
                        [length + booleanOffset, height + booleanOffset],
                        [length - chamfer, height],
                    ]);
                    polygon([
                        [-booleanOffset, -booleanOffset],
                        [0, chamfer],
                        [chamfer, 0],
                    ]);
                    polygon([
                        [length - chamfer, 0],
                        [length, chamfer],
                        [length + booleanOffset, -booleanOffset],
                    ]);
                };
            };
            rotate([0, -90, 0]) {
                linear_extrude(height = 2 * length + booleanOffset, center = true) {
                    polygon([
                        [-booleanOffset, (width + taper) / 2 + booleanOffset],
                        [chamfer, (width + taper) / 2],
                        [0, (width + taper) / 2 - chamfer],
                    ]);
                    polygon([
                        [-booleanOffset, -(width + taper) / 2 - booleanOffset],
                        [chamfer, -(width + taper) / 2],
                        [0, -(width + taper) / 2 + chamfer],
                    ]);
                    polygon([
                        [height + booleanOffset, (width + taper) / 2 + booleanOffset],
                        [height - chamfer, (width + taper) / 2],
                        [height, (width + taper) / 2 - chamfer],
                    ]);
                    polygon([
                        [height + booleanOffset, -(width + taper) / 2 - booleanOffset],
                        [height - chamfer, -(width + taper) / 2],
                        [height, -(width + taper) / 2 + chamfer],
                    ]);
                };
            };
        };
    };
};

module cutout () {
    symmetry() {
        polygon([
            [length * (taperPosition - taperLength / 2.0), width / 2 - wall],
            [length * taperPosition, (width + taper) / 2 - wall],
            [length * (taperPosition + taperLength / 2.0), width / 2 - wall],
            [length - wall, width / 2 - wall],
            [length - wall, 0],
            [wall, 0],
            [wall, width / 2 - wall],
        ]);
    };
};

module grip () {
    thickness = 1.0;
    spacing = 1.0;

    union() {
        gripBlade(thickness);
        translate([(thickness + spacing), 0, 0]) {
            gripBlade(thickness - 0.2);
        };
    };
};

module gripBlade (thickness) {
    chamfer = 0.4;

    difference() {
        linear_extrude(height = height) {
            polygon([
                [thickness, gripWidth / 2],
                [thickness, -gripWidth / 2],
                [chamfer, -gripWidth / 2],
                [0, -(gripWidth / 2 - chamfer)],
                [0, (gripWidth / 2 - chamfer)],
                [chamfer, gripWidth / 2]
            ]);
        }
        
        rotate([90, 0, 0]) {
            linear_extrude(height = gripWidth + booleanOffset, center = true) {
                polygon([
                    [-booleanOffset, height + booleanOffset],
                    [chamfer, height],
                    [0, height - chamfer],
                ]);
                polygon([
                    [thickness, height - chamfer],
                    [thickness + booleanOffset, height + booleanOffset],
                    [thickness - chamfer, height],
                ]);
                polygon([
                    [-booleanOffset, -booleanOffset],
                    [0, chamfer],
                    [chamfer, 0],
                ]);
                polygon([
                    [thickness - chamfer, 0],
                    [thickness, chamfer],
                    [thickness + booleanOffset, -booleanOffset],
                ]);
            };
        };
    };
};

// Utilities

module symmetry () {
    union() {
        children();
        mirror([0,1,0]) {
            children();
        };
    };
};