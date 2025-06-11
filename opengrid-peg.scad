$fn = 64;

/*/////////////////////////
    PARAMETRIC PEG
*//////////////////////////
        
peg_body_length = 20;
peg_body_diameter = 10;

// If checked, there will be a cap at the end of the peg to prevent objects from slipping off.
// Its thickness is 2mm and its diameter is 25% larger than the peg's diameter.
peg_cap = true;

/* [Hidden] */

peg_cap_length = 2;
peg_cap_diameter = peg_body_diameter * 1.25;

module torus(main_radius, tube_radius) {
    rotate_extrude() {
        translate([main_radius, 0, 0]) {
            circle(r = tube_radius);
        };
    };
};

module filleted_flange(inner_diameter, outer_diameter) {
    fillet_radius = outer_diameter - inner_diameter;
    torus_radius = min(inner_diameter/2 + fillet_radius, 20);

    difference() {
        cylinder(h = fillet_radius, r = torus_radius);
        
        translate([0, 0, fillet_radius]) {
            torus(main_radius = torus_radius, 
                  tube_radius = fillet_radius - 0.01);
        };
    };
};

module peg_cap(length, diameter) {
    // Peg cap of 0 means no cap, just round off the end
    if (length == 0) {
        sphere_radius = diameter * 0.2;
        adjusted_length = 0.001;
        adjusted_diameter = diameter - sphere_radius*3;
        
        translate([0, 0, 0]) {
            minkowski() {
                // peg cap
                cylinder(h = adjusted_length, d = adjusted_diameter);
                // filleting sphere, sized to make the cap edge round
                sphere(r = sphere_radius);
            };
        };

    } else {
        sphere_radius = length/2;
        adjusted_length = length - sphere_radius;
        adjusted_diameter = diameter - sphere_radius*2;
    
        translate([0, 0, sphere_radius]) {
            minkowski() {
                // peg cap
                cylinder(h = adjusted_length, d = adjusted_diameter);
                // filleting sphere, sized to make the cap edge round
                sphere(r = sphere_radius);
            };
        };
    }
};

module peg(body_length, body_diameter, cap_length, cap_diameter) {   
    union() {

        // peg body
        cylinder(h = body_length, d = body_diameter);
        
        // peg cap (at top of peg body)
        translate([0, 0, body_length]) {
            peg_cap(length = cap_length, diameter = cap_diameter);
        };
        
        // peg cap chamfer
        if (cap_length > 0) {
            chamfer_depth = (cap_diameter - body_diameter)/2;
            translate([0, 0, body_length - chamfer_depth]) {
                cylinder(h = chamfer_depth + cap_length/2 , 
                         d1 = body_diameter, 
                         d2 = body_diameter + chamfer_depth*2);
            };
        };
    };
};

/*/////////////////////////
    OPENGRID DIRECTIONAL SNAP
*//////////////////////////

side_length = 18.2745;
short_side_length = 15.1632;
full_side_length = 25;
cutout_offset = (full_side_length - side_length) / 2;
large_cutout_offset = (full_side_length - short_side_length) / 2;
short_tab_length = 10.8;

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

/*/////////////////////////
    ASSEMBLE THE SNAP PEG
*//////////////////////////

union() {
    // Bare openGrid Snap (Regular)
    opengrid_directional_snap();
    snap_thickness = 6.8; // measured value from an actual snap
    
    translate([12.5, 12.5, snap_thickness]) {
        // Fillet at base of peg
        filleted_flange(inner_diameter = peg_body_diameter, 
                        outer_diameter = min(peg_body_diameter*1.33, 22));
        
        // Completed peg with cap
        peg(body_length = peg_body_length, 
            body_diameter = peg_body_diameter,
            cap_length = peg_cap ? peg_cap_length : 0,
            cap_diameter = peg_cap_diameter);
    };
};

