// openGrid snap type for connecting to base plates.
snap_type = "Directional"; // [Lite, Full, Directional]

// The fitment affects the tightness of the snap when mounted (ease of removing the peg)
// Use a value between 0.0 and 1.0, with 0.5 meaning a standard fit.
// A value between 0.66-0.75 would be a tight fit, and a value of 1.0 would be very difficult to insert and remove.
snap_fitment = 0.66;

/* [Hidden] */

/*///////////////////////////
    OPENGRID SNAP
*////////////////////////////

cell_width = 28;
snap_width = 25;
snap_wall = cell_width - snap_width; // thickness of wall between snaps
snap_margin = snap_wall / 2; // thickness of one cell's portion of the wall
long_side_length = 18.2745;
short_side_length = 15.1632;
cutout_offset = (snap_width - long_side_length) / 2;
large_cutout_offset = (snap_width - short_side_length) / 2;
short_tab_length = 10.8;

part_overlap = 0.05; // For ensuring manifold geometry during boolean operations

full_snap_thickness = 6.8;
lite_snap_thickness = 3.4;
snap_diff_thickness = full_snap_thickness - lite_snap_thickness;

module large_corner_cutouts() {
    linear_extrude(height = 5.3)
        polygon(
            points = [
                [0,0],
                [0, large_cutout_offset],
                [large_cutout_offset, 0],
                [0, snap_width-large_cutout_offset],
                [0, snap_width],
                [large_cutout_offset, snap_width],
                [snap_width-large_cutout_offset, snap_width],
                [snap_width, snap_width],
                [snap_width, snap_width-large_cutout_offset],
                [snap_width, large_cutout_offset],
                [snap_width, 0],
                [snap_width-large_cutout_offset, 0]
            ],
            paths = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]]
        );
};

module corner_overhang_cutout_template() {
    translate([0, 0, 5.3])
        rotate([90, 0, 45])
            linear_extrude(height = 10)
                polygon(
                    points = [
                        [0, 0],
                        [0, 1.1],
                        [1.1, 0]
                    ]
                );
};

module corner_overhang_cutouts() {
    translate([-.8, 4.162, 0])
        corner_overhang_cutout_template();
    
    rotate([0, 0, 90])
        translate([-1.65, -20,0])
            corner_overhang_cutout_template();
    
    rotate([0, 0, -90])
        translate([-27, 5.353, 0])
            corner_overhang_cutout_template();
    
    rotate([0, 0, 180])
        translate([-27, -19.64, 0])
            corner_overhang_cutout_template();
};

module bottom_slot_cutout_template() {
    hull()
        linear_extrude(height = 6.2) {
            circle(r = 0.4);
            translate([11.8, 0, 0]) {
                circle(r = 0.4);
            };
        };
};

module bottom_slot_cutouts(snap_type) {
    slot_inset = 1.5;

    if (snap_type == "Directional") {
        rotate([13, 0, 0])
            translate([6.75, slot_inset,-7])
                scale([1, 1, 2])
                    bottom_slot_cutout_template();
    } else {
        translate([6.75, slot_inset,-7])
            scale([1, 1, 2])
                bottom_slot_cutout_template();
    }

    // Left side
    translate([slot_inset, 7, -0.01])
        rotate([0, 0, 90])
            bottom_slot_cutout_template();
    
    // Right side
    translate([snap_width - slot_inset, 7, -0.01])
        rotate([0, 0, 90])
            bottom_slot_cutout_template();
    
    // Top, for non-Directional snaps
    if (snap_type != "Directional") {
        translate([6.75, snap_width - slot_inset,-7])
            scale([1, 1, 2])
                bottom_slot_cutout_template();
    }
};

// Generates a cutout of an equilateral triangle
// used to emboss as a directional indicator for Directional snaps
module triangle_directional_cutout_template(side_length, thickness) {

    height = side_length * 0.866; // sin60 = 0.866

    linear_extrude(height = thickness)
        polygon(
            points = [
                [0, 0],
                [side_length, 0],
                [side_length / 2.0, height],
            ],
        );
};

module triangle_directional_cutout() {
    triangle_side_length = 3;
    cutout_thickness = 0.4;

    translate([(snap_width-triangle_side_length)/2, snap_width - 6, -0.1])
        triangle_directional_cutout_template(triangle_side_length, cutout_thickness);
};

module side_slot_cutouts(snap_type) {
    length = 11.4;
    width = 1;
    height = 0.4;
    top_shelf_thickness = 1.2;
    top_distance = full_snap_thickness - top_shelf_thickness;
    
    // Left side
    translate([.75, 7, top_distance])
        rotate([0, 0, 90])
            cube([length, width, height]);
    
    // Right side
    translate([snap_width-width+width, 7, top_distance])
        rotate([0, 0, 90])
            cube([length, width, height]);
    
    // Bottom
    translate([7, 0, top_distance])
        cube([length, width, height]);
    
    // Top, for non-Directional snaps
    if (snap_type != "Directional") {
        translate([7, snap_width, top_distance])
            cube([length, width, height]);
    }
};

module snap_tab(x_scale, y_scale, z_scale) {
    base_x = 14 * x_scale;
    base_y = 4 * y_scale;
    top_x = 9.5 * x_scale;
    top_y = 2.2 * y_scale;
    height = 0.8 * z_scale;

    // Offsets to center the top over the base
    dx = (base_x - top_x) / 2;
    dy = (base_y - top_y) / 2;

    points = [
        // Base (Z = 0)
        [0,      0,      0],  // 0, bottom-left of big face
        [base_x, 0,      0],  // 1, bottom-right of big face
        [base_x, base_y, 0],  // 2, top-right of big face
        [0,      base_y, 0],  // 3, top-left of big face

        // Top (Z = height), centered
        [dx,        dy,        height],  // 4, bottom-left of small face
        [dx+top_x,  dy,        height],  // 5, bottom-right of small face
        [dx+top_x,  dy+top_y,  height],  // 6, top-right of small face
        [dx,        dy+top_y,  height]   // 7, top-left of small face
    ];

    faces = [
        [0, 3, 2, 1],  // bottom
        [0, 1, 5, 4],  // side 1, front
        [0, 4, 7, 3],  // side 2, left
        [1, 2, 6, 5],  // side 3, right
        [2, 3, 7, 6],  // side 4, rear
        [4, 5, 6, 7],  // top
    ];

    polyhedron(points=points, faces=faces);
};

module snap_tab_large(fitment) {
    snap_tab(x_scale = 1.0, y_scale = 1.0, z_scale = fitment);
};

module snap_tab_small(fitment) {
    snap_tab(x_scale = 0.8, y_scale = 0.5, z_scale = fitment);
};

module top_tab(type, fitment) {
    // full or lite tab for top edge
    if (type == "Directional") {
        // full tab for directional snaps
        translate([(snap_width+14)/2, snap_width - part_overlap, 1.4])
            rotate([90, 0, 180])
                snap_tab_large(fitment = 1.0);
    } else {
        // lite tab for non-directional snaps
        translate([(snap_width+short_tab_length)/2+0.4, snap_width - part_overlap, snap_diff_thickness])
            rotate([90, 0, 180])
                snap_tab_small(fitment);
    }
};

module right_tab(fitment) {
    translate([snap_width - part_overlap, (snap_width-short_tab_length)/2, snap_diff_thickness])
        rotate([90, 0, 90])
            snap_tab_small(fitment);
};

module left_tab(fitment) {
    translate([part_overlap, (snap_width+short_tab_length)/2+0.4, snap_diff_thickness])
        rotate([90, 0, -90])
            snap_tab_small(fitment);
};

module bottom_tab(fitment) {
    translate([(snap_width-short_tab_length)/2, part_overlap, snap_diff_thickness])
        rotate([90, 0, 0])
            snap_tab_small(fitment);
};

module lite_snap_cutout() {
    linear_extrude(height = snap_diff_thickness)
        polygon(
            points = [
                [0, 0],
                [0, 30],
                [30, 30],
                [30, 0]
            ]
        );
}

module bottom_half_snapfit_cutter() {
    rotate([90, 0, 90])
        linear_extrude(height = 20)
            polygon(
                points = [
                    [0, 0],
                    [0.8, 0], 
                    [0, 3.4]
                ]
            );
};

module bottom_half_snapfit_cutouts() {
    translate([3, 0, 0])
        bottom_half_snapfit_cutter();

    translate([snap_width-cutout_offset-1.555, 0, 0])
        rotate([0, 0, 45])
            bottom_half_snapfit_cutter();
            
    translate([-3, 7.918, 0])
        rotate([0, 0, -45])
            bottom_half_snapfit_cutter();
};

module primary_box() {
    linear_extrude(height = full_snap_thickness)
        polygon(
            points = [
                [0, cutout_offset],
                [0, cutout_offset+long_side_length],
                [cutout_offset, snap_width],
                [cutout_offset+long_side_length, snap_width],
                [snap_width, cutout_offset+long_side_length],
                [snap_width, cutout_offset],
                [cutout_offset+long_side_length, 0],
                [cutout_offset, 0]
            ]
        );
};

module opengrid_snap(snap_type, fitment) {
    union() {
        difference() {
            primary_box();

            large_corner_cutouts();
            corner_overhang_cutouts();

            bottom_slot_cutouts(snap_type);
            side_slot_cutouts(snap_type);
            
            if (snap_type == "Directional") {
                triangle_directional_cutout();
                bottom_half_snapfit_cutouts();
            }

            if (snap_type == "Lite") {
                lite_snap_cutout();
            }
        };
        top_tab(type = snap_type, fitment = fitment);
        bottom_tab(fitment = fitment);
        left_tab(fitment = fitment);
        right_tab(fitment = fitment);
    };
};


/*///////////////////////////
    FINAL ASSEMBLY
*////////////////////////////
render()
    opengrid_snap(snap_type = "Directional", fitment = 0.66);

