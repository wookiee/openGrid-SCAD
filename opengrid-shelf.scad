/* [Shelf Parameters] */

// Dimensions are in millimeters. Multiple shelves can fit side-by-side on the grid if your Shelf Width is an odd multiple of 28mm, such as 112mm or 196mm.
shelf_width = 84;
shelf_depth = 170;

/* [Hidden] */

// Hidden shelf parameters
shelf_thickness = 5;
shelf_lip_height = 5;
min_snaps = 1;
max_snaps = floor(shelf_width/28);
outer_face_outset = 3;
outer_face_bottom = 3;
outer_face_top = 5;
lip_top_height = 8;
lip_top_thickness = 2;
tray_edge_inset = outer_face_outset + lip_top_thickness;

// Hidden snap parameters
side_length = 18.2745;
short_side_length = 15.1632;
cell_width = 28;
full_side_length = 25;
cutout_offset = (full_side_length - side_length) / 2;
large_cutout_offset = (full_side_length - short_side_length) / 2;
short_tab_length = 10.8;
snap_height = 6.8;

/*///////////////////////////
    SHELF
*////////////////////////////

module shelf_blank() {
    // The points are grouped by corner, starting with the southwest (bottom-left) corner
    // For each corner, point 0 is on bottom of the shelf, and are ordered along the corner's edge to the outside, then up to the lip, and ending with the matching corner of the tray's inner face
    polyhedron(
        points = [
            // SW corner
            [outer_face_outset, outer_face_outset, 0], // SW corner of bottom face
            [0, 0, outer_face_bottom], // SW corner bottom of W face
            [0, 0, outer_face_top], // SW corner top of W face
            [outer_face_outset, outer_face_outset, lip_top_height], // SW outer corner of top of lip
            [lip_top_thickness, lip_top_thickness, lip_top_height], // SW inner corner of top lip
            [tray_edge_inset, tray_edge_inset, shelf_thickness], // SW corner of shelf top surface
            
            // NW corner
            [outer_face_outset, shelf_depth, 0],
            [0, shelf_depth-outer_face_outset, outer_face_bottom],
            [0, shelf_depth-outer_face_outset, outer_face_top],
            [outer_face_outset, shelf_depth, lip_top_height],
            [lip_top_thickness, shelf_depth-lip_top_thickness, lip_top_height],
            [tray_edge_inset, shelf_depth-tray_edge_inset, shelf_thickness],
            
            // NE corner
            [shelf_width-outer_face_outset, shelf_depth, 0],
            [shelf_width, shelf_depth-outer_face_outset, outer_face_bottom],
            [shelf_width, shelf_depth-outer_face_outset, outer_face_top],
            [shelf_width-outer_face_outset, shelf_depth, lip_top_height],
            [shelf_width-lip_top_thickness, shelf_depth-lip_top_thickness, lip_top_height],
            [shelf_width-tray_edge_inset, shelf_depth-tray_edge_inset, shelf_thickness],
            
            // SE corner
            [shelf_width-outer_face_outset, outer_face_outset, 0],
            [shelf_width, 0, outer_face_bottom],
            [shelf_width, 0, outer_face_top],
            [shelf_width-outer_face_outset, outer_face_outset, lip_top_height],
            [shelf_width-lip_top_thickness, lip_top_thickness, lip_top_height],
            [shelf_width-tray_edge_inset, tray_edge_inset, shelf_thickness]
        ],
        faces = [
            [0, 6, 12, 18], // bottom face
            
            [0, 1, 7, 6], // W outer bottom chamfer
            [1, 2, 8, 7], // W outer face
            [2, 3, 9, 8], // W outer top chamfer
            [3, 4, 10, 9], // W lip top face
            [4, 5, 11, 10], // W inner chamfer
            
            [6, 7, 8, 9, 15, 14, 13, 12], // N face
            [9, 10, 16, 15], // N lip top face
            [11, 10, 16, 17], // N inner chamfer
            
            [12, 13, 19, 18], // E outer bottom chamfer
            [13, 14, 20, 19], // E outer face
            [14, 15, 21, 20], // E outer top chamfer
            [15, 16, 22, 21], // E lip top face
            [16, 17, 23, 22], // E inner chamfer
            
            [18, 19, 1, 0], // S outer bottom chamfer
            [19, 20, 2, 1], // S outer face
            [20, 21, 3, 2], // S outer top chamfer
            [21, 22, 4, 3], // S lip top face
            [22, 23, 5, 4], // S inner chamfer
            
            [5, 11, 17, 23] // top face
        ]
    );
};

/*///////////////////////////
    OPENGRID DIRECTIONAL SNAP
*////////////////////////////

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
    top_distance = 6.8 - 1.2;
    
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

module snap_tabs() {
    // large tab at gravitational top
    translate([(full_side_length+14)/2, full_side_length, 1.4])
        rotate([90, 0, 180])
            snap_tab_large_template();
    
    // short tab at bottom
    translate([(full_side_length-short_tab_length)/2, 0, 3.4])
        rotate([90, 0, 0])
            scale([0.8, 0.5, 0.5])
                snap_tab_large_template();
    
    // short tab on left
    translate([0, (full_side_length+short_tab_length)/2+0.4, 3.4])
        rotate([90, 0, -90])
            scale([0.8, 0.5, 0.5])
                snap_tab_large_template();
    
    // short tab on right
    translate([full_side_length, (full_side_length-short_tab_length)/2, 3.4])
        rotate([90, 0, 90])
            scale([0.8, 0.5, 0.5])
                snap_tab_large_template();
};

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
    linear_extrude(height = 6.8)
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

module opengrid_directional_snap() {
    union() {
        difference() {
            primary_box();
            large_corner_cutouts();
            corner_overhang_cutouts();
            bottom_slot_cutouts();
            triangle_directional_cutout();
            side_slot_cutouts();
            bottom_half_snapfit_cutouts();
        };
        snap_tabs();
    };
};


/*///////////////////////////
    FINAL ASSEMBLY
*////////////////////////////

module snap_chamfer() {
    translate([full_side_length, full_side_length/6, snap_height])
        rotate([90, -90, -90])
            linear_extrude(height = full_side_length)
                polygon(
                    points = [
                        [0, 0],
                        [lip_top_thickness*2, 0],
                        [0, lip_top_height + 8]
                    ],
                    paths = [[0, 1, 2]]
                );
};

snap_width = full_side_length;
snap_margin = (cell_width - snap_width) / 2; // 1.5mm
total_width = shelf_width;

cell_count = floor(shelf_width / cell_width);

even_cell_count = (cell_count % 2 == 0) ? true : false;
snap_count = (even_cell_count) ? floor(cell_count / 2) : floor(cell_count / 2) + 1;
even_snap_count = (snap_count % 2 == 0) ? true : false;
gap_count = (even_cell_count) ? floor(cell_count / 2) - 1 : floor(cell_count/2);
gap_width = cell_width;

snap_remainder = shelf_width - (cell_count * cell_width);
outer_snap_offset = even_cell_count ? (snap_remainder + cell_width)/2 : snap_remainder / 2;

union() { 
    translate([-outer_snap_offset - snap_margin, snap_width/6, shelf_depth+snap_height])
        rotate([-90, 0, 0])
            shelf_blank();

    for (i = [0 : snap_count - 1]) {
        translate([i * (cell_width * 2), 0, 0])
            union() {
                snap_chamfer();
                opengrid_directional_snap();
            };
    }
};