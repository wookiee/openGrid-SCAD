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

side_length = 18.2745;
short_side_length = 15.1632;
full_side_length = 25;
cutout_offset = (full_side_length - side_length) / 2;
large_cutout_offset = (full_side_length - short_side_length) / 2;
short_tab_length = 10.8;

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
                [0, full_side_length-large_cutout_offset],
                [0, full_side_length],
                [large_cutout_offset, full_side_length],
                [full_side_length-large_cutout_offset, full_side_length],
                [full_side_length, full_side_length],
                [full_side_length, full_side_length-large_cutout_offset],
                [full_side_length, large_cutout_offset],
                [full_side_length, 0],
                [full_side_length-large_cutout_offset, 0]
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
                    ],
                    paths = [[0, 1, 2]]
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

module bottom_slot_cutouts() {
    rotate([13, 0, 0])
        translate([6.75, 2,-7])
            scale([1, 1, 2])
            bottom_slot_cutout_template();

    translate([1, 7, -0.01])
        rotate([0, 0, 90])
            bottom_slot_cutout_template();
    
    translate([24, 7, -0.01])
        rotate([0, 0, 90])
            bottom_slot_cutout_template();
};

module triangle_directional_cutout_template() {
    base_size = 3;
    top_scale = 0.75;
    height = 0.4;
    sin60 = 0.866;
    cos60 = 0.5;
    
    // 2D base triangle points
    base = [
        [0, -base_size],
        [base_size * sin60, base_size * cos60],
        [-base_size * sin60, base_size * cos60]
    ];
    
    // Convert to 3D
    base_3d = [ for (v = base) [v[0], v[1], 0] ];
    top     = [ for (v = base) [v[0] * top_scale, v[1] * top_scale, height] ];
    
    points = concat(base_3d, top);
    
    faces = [
        [0, 1, 2],       // bottom
        [3, 4, 5],       // top
        [0, 1, 4], [0, 4, 3],   // side 1
        [1, 2, 5], [1, 5, 4],   // side 2
        [2, 0, 3], [2, 3, 5]    // side 3
    ];
    
    polyhedron(points = points, faces = faces);
};

module triangle_directional_cutout() {
    translate([full_side_length/2, full_side_length*0.85, -0.1])
        rotate([0, 0, 180])
            triangle_directional_cutout_template();
};

module side_slot_cutouts() {
    length = 11.4;
    width = 1;
    height = 0.4;
    top_shelf_thickness = 1.2;
    top_distance = full_snap_thickness - top_shelf_thickness;
    
    translate([.75, 7, top_distance])
        rotate([0, 0, 90])
            cube([length, width, height]);
            
    translate([full_side_length-width+width, 7, top_distance])
        rotate([0, 0, 90])
            cube([length, width, height]);
    
    translate([7, 0, top_distance])
        cube([length, width, height]);
        
};

module snap_tab_large_template() {
    base_x = 14;
    base_y = 4;
    top_x = 9.5;
    top_y = 2.2;
    height = 0.8;

    // Offsets to center the top over the base
    dx = (base_x - top_x) / 2;
    dy = (base_y - top_y) / 2;

    points = [
        // Base (Z = 0)
        [0,      0,      0],  // 0
        [base_x, 0,      0],  // 1
        [base_x, base_y, 0],  // 2
        [0,      base_y, 0],  // 3

        // Top (Z = height), centered
        [dx,        dy,        height],  // 4
        [dx+top_x,  dy,        height],  // 5
        [dx+top_x,  dy+top_y,  height],  // 6
        [dx,        dy+top_y,  height]   // 7
    ];

    faces = [
        [0, 1, 2, 3],  // bottom
        [4, 5, 6, 7],  // top
        [0, 1, 5, 4],  // side 1
        [1, 2, 6, 5],  // side 2
        [2, 3, 7, 6],  // side 3
        [3, 0, 4, 7]   // side 4
    ];

    polyhedron(points=points, faces=faces);
};

module snap_tab_small_template(fitment) {
    scale([0.8, 0.5, fitment])
        snap_tab_large_template();
}

module snap_tabs(type, fitment) {

    // full or lite tab for top edge
    if (type == "Directional") {
        translate([(full_side_length+14)/2, full_side_length, 1.4])
            rotate([90, 0, 180])
                snap_tab_large_template();
    } else {
        translate([(full_side_length+short_tab_length)/2+0.4, full_side_length, snap_diff_thickness])
            rotate([90, 0, 180])
                snap_tab_small_template(fitment);
    }
    
    // short tab at bottom
    translate([(full_side_length-short_tab_length)/2, 0, snap_diff_thickness])
        rotate([90, 0, 0])
            snap_tab_small_template(fitment);
    
    // short tab on left
    translate([0, (full_side_length+short_tab_length)/2+0.4, snap_diff_thickness])
        rotate([90, 0, -90])
            snap_tab_small_template(fitment);
    
    // short tab on right
    translate([full_side_length, (full_side_length-short_tab_length)/2, snap_diff_thickness])
        rotate([90, 0, 90])
            snap_tab_small_template(fitment);
};

module lite_snap_cutout() {
    linear_extrude(height = snap_diff_thickness)
        polygon(
            points = [
                [0, 0],
                [0, 30],
                [30, 30],
                [30, 0]
            ],
            paths = [[0, 1, 2, 3]]
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
                ],
                paths = [[0, 1, 2]]
            );
};

module bottom_half_snapfit_cutouts() {
    translate([3, 0, 0])
        bottom_half_snapfit_cutter();

    translate([full_side_length-cutout_offset-1.555, 0, 0])
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
                [0, cutout_offset+side_length],
                [cutout_offset, full_side_length],
                [cutout_offset+side_length, full_side_length],
                [full_side_length, cutout_offset+side_length],
                [full_side_length, cutout_offset],
                [cutout_offset+side_length, 0],
                [cutout_offset, 0]
            ],
            paths = [[0, 1, 2, 3, 4, 5, 6, 7]]
        );
};

module opengrid_snap(type, fitment) {
    union() {
        difference() {
            primary_box();
            large_corner_cutouts();
            corner_overhang_cutouts();
            bottom_slot_cutouts();
            if (type == "Directional") {
                triangle_directional_cutout();
            }
            side_slot_cutouts();
            bottom_half_snapfit_cutouts();
            if (type == "Lite") {
                lite_snap_cutout();
            }
        };
        snap_tabs(type = type, fitment = fitment);
    };
};


/*///////////////////////////
    FINAL ASSEMBLY
*////////////////////////////

opengrid_snap(type = "Directional", fitment = 0.66);