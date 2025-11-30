height = 3.791;
length = 22.1;
width = 4.0;
taper = 0.743;
taperPosition = 0.57;
taperLength = 0.62;
wall = 1.6;
gripWidth = 8.0;
chamfer = 0.5;
booleanOffset = 0.1;

pin();

module pin () {
    difference() {
        union() {
            difference() {
                mainBody();
                mainBodyChamfer();
            };
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
    x = width / 2;
    tX = x + (taper / 2);
    
    t1 = length * (taperPosition - (taperLength / 2));
    t2 = (length * taperPosition) - (chamfer / 2);
    t3 = length * (taperPosition + (taperLength / 2));

    rotate([90, 0, 90]) {
        linear_extrude(length) polygon([
            [-x, height - chamfer],
            [-x + chamfer, height],
            [x - chamfer, height],
            [x, height - chamfer],
            [x, chamfer],
            [x - chamfer, 0],
            [-x + chamfer, 0],
            [-x, chamfer],
        ]);
        
        hull() {
        translate([0, 0, t1]) linear_extrude(1) polygon([
            [-x, height - chamfer],
            [-x + chamfer, height],
            [x - chamfer, height],
            [x, height - chamfer],
            [x, chamfer],
            [x - chamfer, 0],
            [-x + chamfer, 0],
            [-x, chamfer],
        ]);
        
        translate([0, 0, t2]) linear_extrude(chamfer) polygon([
            [-tX, height - chamfer],
            [-tX + chamfer, height],
            [tX - chamfer, height],
            [tX, height - chamfer],
            [tX, chamfer],
            [tX - chamfer, 0],
            [-tX + chamfer, 0],
            [-tX, chamfer],
        ]);
        
        translate([0, 0, t3 - 1]) linear_extrude(1) polygon([
            [-x, height - chamfer],
            [-x + chamfer, height],
            [x - chamfer, height],
            [x, height - chamfer],
            [x, chamfer],
            [x - chamfer, 0],
            [-x + chamfer, 0],
            [-x, chamfer],
        ]);
        };
    };
};

module mainBodyChamfer() {
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
    linear_extrude(height = 2 * length + booleanOffset, center = true) {
        polygon([
            [length - chamfer, width / 2],
            [length + booleanOffset, width / 2 + booleanOffset],
            [length, width / 2 - chamfer],
        ]);
        polygon([
            [length - chamfer, -width / 2],
            [length, -(width / 2 - chamfer)],
            [length + booleanOffset, -(width / 2 + booleanOffset)],
        ]);
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
    children();
    mirror([0,1,0]) {
        children();
    };
};
