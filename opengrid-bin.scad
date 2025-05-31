/* [Bin Parameters] */

bin_width = 150;
bin_height = 50;
bin_depth = 50;

wall_thickness = 3;
floor_thickness = 3;

width_sub_bins = 3;
depth_sub_bins = 2;
sub_bin_wall_thickness = 2;

/* [Hidden] */

wall_chamfer_outer = wall_thickness * 1.5;
wall_chamfer_inner = wall_thickness;
lip_chamfer = wall_thickness/2;

$fn = 64;

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
    BIN
*////////////////////////////

module bin() {
	polyhedron(
		points = [
		
			/* SW Corner */ 
		
			// SW bottom outer corner
				/* 00 */ [wall_chamfer_outer, wall_chamfer_outer, 0], // bottom
				/* 01 */ [wall_chamfer_outer, 0, wall_chamfer_outer], // S
				/* 02 */ [0, wall_chamfer_outer, wall_chamfer_outer], // W
			
			// SW top/lip corner, S seam
				/* 03 */ [wall_chamfer_outer, 0, bin_height - lip_chamfer], // outer
				/* 04 */ [wall_chamfer_outer + wall_thickness/4, wall_thickness/2, bin_height], // top
				/* 05 */ [wall_chamfer_outer + wall_thickness/2, wall_thickness, bin_height - lip_chamfer], // inner
			
			// SW top/lip corner, W seam
				/* 06 */ [0, wall_chamfer_outer, bin_height - lip_chamfer], // outer
				/* 07 */ [wall_thickness/2, wall_chamfer_outer + wall_thickness/4, bin_height], // top
				/* 08 */ [wall_thickness, wall_chamfer_outer + wall_thickness/2, bin_height - lip_chamfer], // inner
			
			// SW bottom inner corner
				/* 09 */ [wall_chamfer_outer + wall_thickness/2, wall_thickness, floor_thickness + wall_chamfer_inner], // S
				/* 10 */ [wall_thickness, wall_chamfer_outer + wall_thickness/2, floor_thickness + wall_chamfer_inner], // W
				/* 11 */ [wall_thickness + wall_chamfer_inner, wall_thickness + wall_chamfer_inner, floor_thickness], // bottom
			
			/* NW Corner */
			
			// NW bottom outer corner
				/* 12 */ [wall_chamfer_outer, bin_depth - wall_chamfer_outer, 0], // bottom
				/* 13 */ [0, bin_depth - wall_chamfer_outer, wall_chamfer_outer], // W
				/* 14 */ [wall_chamfer_outer, bin_depth, wall_chamfer_outer], // N
			
			// NW top/lip corner, W seam
				/* 15 */ [0, bin_depth - wall_chamfer_outer, bin_height - lip_chamfer], // outer
				/* 16 */ [wall_thickness/2, bin_depth - (wall_chamfer_outer + wall_thickness/4), bin_height], // top
				/* 17 */ [wall_thickness, bin_depth - (wall_chamfer_outer + wall_thickness/2), bin_height - lip_chamfer], // inner
			
			// NW top/lip corner, N seam
				/* 18 */ [wall_chamfer_outer, bin_depth, bin_height - lip_chamfer], // outer
				/* 19 */ [wall_chamfer_outer + wall_thickness/4, bin_depth - wall_thickness/2, bin_height], // top
				/* 20 */ [wall_chamfer_outer + wall_thickness/2, bin_depth - wall_thickness, bin_height - lip_chamfer], // inner
			
			// NW bottom inner corner
				/* 21 */ [wall_thickness, bin_depth - (wall_chamfer_outer + wall_thickness/2), floor_thickness + wall_chamfer_inner], // W
				/* 22 */ [wall_thickness + wall_chamfer_inner, bin_depth - wall_thickness, floor_thickness + wall_chamfer_inner], // N
				/* 23 */ [wall_thickness + wall_chamfer_inner, bin_depth - (wall_thickness + wall_chamfer_inner), floor_thickness], // bottom
			
			/* NE Corner */
			
			// NE bottom outer corner
				/* 24 */ [bin_width - wall_chamfer_outer, bin_depth - wall_chamfer_outer, 0], // bottom
				/* 25 */ [bin_width, bin_depth - wall_chamfer_outer, wall_chamfer_outer], // E
				/* 26 */ [bin_width - wall_chamfer_outer, bin_depth, wall_chamfer_outer], // N
			
			// NE top/lip corner, E seam 
				/* 27 */ [bin_width, bin_depth - wall_chamfer_outer, bin_height - lip_chamfer], // outer
				/* 28 */ [bin_width - wall_thickness/2, bin_depth - (wall_chamfer_outer + wall_thickness/4), bin_height], // top
				/* 29 */ [bin_width - wall_thickness, bin_depth - (wall_chamfer_outer + wall_thickness/2), bin_height - lip_chamfer], // inner
			
			// NE top/lip corner, N seam
				/* 30 */ [bin_width - wall_chamfer_outer, bin_depth, bin_height - lip_chamfer], // outer
				/* 31 */ [bin_width - (wall_chamfer_outer + wall_thickness/4), bin_depth - wall_thickness/2, bin_height], // top
				/* 32 */ [bin_width - (wall_chamfer_outer + wall_thickness/2), bin_depth - wall_thickness, bin_height - lip_chamfer], // inner
			
			// NE bottom inner corner
				/* 33 */ [bin_width - wall_thickness, bin_depth - (wall_chamfer_outer + wall_thickness/2), floor_thickness + wall_chamfer_inner], // E
				/* 34 */ [bin_width - (wall_chamfer_outer + wall_thickness/2), bin_depth - wall_thickness, floor_thickness + wall_chamfer_inner], // N
				/* 35 */ [bin_width - (wall_thickness + wall_chamfer_inner), bin_depth - (wall_thickness + wall_chamfer_inner), floor_thickness], // bottom
			
			/* SE Corner */
			
			// SE bottom outer corner
				/* 36 */ [bin_width - wall_chamfer_outer, wall_chamfer_outer, 0], // bottom
				/* 37 */ [bin_width - wall_chamfer_outer, 0, wall_chamfer_outer], // S
				/* 38 */ [bin_width, wall_chamfer_outer, wall_chamfer_outer], // E
			
			// SE top/lip corner, S seam
				/* 39 */ [bin_width - wall_chamfer_outer, 0, bin_height - lip_chamfer], // outer
				/* 40 */ [bin_width - (wall_chamfer_outer + wall_thickness/4), wall_thickness/2, bin_height], // top
				/* 41 */ [bin_width - (wall_chamfer_outer + wall_thickness/2), wall_thickness, bin_height - lip_chamfer], // inner
			
			// SE top/lip corner, E seam
				/* 42 */ [bin_width, wall_chamfer_outer, bin_height - lip_chamfer], // outer
				/* 43 */ [bin_width - wall_thickness/2, wall_chamfer_outer + wall_thickness/4, bin_height], // top
				/* 44 */ [bin_width - wall_thickness, wall_chamfer_outer + wall_thickness/2, bin_height - lip_chamfer], // inner
			
			// SE bottom inner corner
				/* 45 */ [bin_width - (wall_chamfer_outer + wall_thickness/2), wall_thickness, floor_thickness + wall_chamfer_inner], // S
				/* 46 */ [bin_width - wall_thickness, wall_chamfer_outer + wall_thickness/2, floor_thickness + wall_chamfer_inner], // E
				/* 47 */ [bin_width - (wall_thickness + wall_chamfer_inner), wall_thickness + wall_chamfer_inner, floor_thickness], // bottom
		],
		faces = [
			// SW Corner
			[0, 1, 2],	        // outer bottom face
			[1, 2, 6, 3],       // outer face
			[3, 4, 7, 6],       // outer lip
			[4, 5, 8, 7],       // inner lip
			[5, 8, 10, 9],      // inner face
			[9, 10, 11],        // inner bottom face
			
			// W Wall
            [0, 2, 13, 12],     // outer bottom face
            [2, 6, 15, 13],     // outer face
            [6, 7, 16, 15],     // outer lip
            [7, 8, 17, 16],     // inner lip
            [8, 10, 21, 17],    // inner face
            [10, 11, 23, 21],   // inner bottom face 
			
			// NW Corner
			[12, 13, 14],       // outer bottom face
			[13, 14, 18, 15],   // outer face
			[15, 16, 19, 18],   // outer lip
			[16, 17, 20, 19],   // inner lip
			[17, 21, 22, 20],   // inner face
			[23, 22, 21],       // inner bottom face
			
			// N Face
            [14, 12, 24, 26],   // outer bottom face
			[18, 14, 26, 30],   // outer face
			[18, 19, 31, 30],   // outer lip
			[19, 20, 32, 31],   // inner lip
			[20, 22, 34, 32],   // inner face
			[22, 23, 35, 34],   // inner bottom face
			
			// NE Corner
            [24, 25, 26],       // outer bottom face
			[26, 25, 27, 30],   // outer face
			[30, 31, 28, 27],   // outer lip
			[31, 32, 29, 28],   // inner lip
			[32, 34, 33, 29],   // inner face
			[33, 34, 35],       // inner bottom face
			
			// E Face
            [25, 24, 36, 38],   // outer bottom face
			[27, 25, 38, 42],   // outer face
			[27, 28, 43, 42],   // outer lip
			[28, 29, 44, 43],   // inner lip
			[29, 33, 46, 44],   // inner face
			[33, 35, 47, 46],   // inner bottom face
			
			// SE Corner
            [36, 37, 38],       // outer bottom face
			[37, 39, 42, 38],   // outer face
			[42, 43, 40, 39],   // outer lip
			[43, 44, 41, 40],   // inner lip
			[46, 45, 41, 44],   // inner face
			[45, 46, 47],       // inner bottom face
			
			// S Face
            [0, 1, 37, 36],    // outer bottom face
			[1, 3, 39, 37],     // outer face
			[4, 3, 39, 40],     // outer lip
			[5, 4, 40, 41],     // inner lip
			[9, 5, 41, 45],     // inner face
			[11, 9, 45, 47],    // inner bottom face
            
            // Bottom/outer face
            [0, 36, 24, 12],
            
            // Top/inner face
			[11, 47, 35, 23]
		]
	);
};

module bin_divider(length) {
    inset = wall_thickness/2;
    adjusted_length = length - wall_thickness;
    sub_bin_lip_chamfer = sub_bin_wall_thickness/2;
    height = bin_height - (lip_chamfer - sub_bin_wall_thickness/2);
    
    polyhedron(
        points = [
            [inset, sub_bin_wall_thickness/2, height], // lip W
            [inset, 0, height - sub_bin_lip_chamfer], // front NW
            [inset, 0, wall_chamfer_inner], // front WSW
            [inset + wall_chamfer_inner, 0, 0], // front SSW
            [length - wall_chamfer_inner, 0, 0], // front SSE
            [length, 0, wall_chamfer_inner], // front ESE
            [length, 0, height - sub_bin_lip_chamfer], // front NE
            [length, sub_bin_wall_thickness/2, height], // lip E
            [length, sub_bin_wall_thickness, height - sub_bin_lip_chamfer], // rear NE
            [length, sub_bin_wall_thickness, wall_chamfer_inner], // rear ESE
            [length - wall_chamfer_inner, sub_bin_wall_thickness, 0], // rear SSE
            [inset + wall_chamfer_inner, sub_bin_wall_thickness, 0], // rear SSW
            [inset, sub_bin_wall_thickness, wall_chamfer_inner], // rear WSW
            [inset, sub_bin_wall_thickness, height - sub_bin_lip_chamfer], // rear NW
        ],
        
        faces = [
            [0, 1, 6, 7], // front lip
            [1, 2, 3, 4, 5, 6], // front face
            [7, 8, 13, 0], // rear lip
            [8, 9, 10, 11, 12, 13], // rear face
            [0, 1, 2, 12, 13], // W edge
            [5, 6, 7, 8, 9], // E edge
            [2, 3, 11, 12], // W bottom chamfer
            [4, 5, 9, 10], // E bottom chamfer
            [3, 4, 10, 11], // bottom edge
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

snap_width = full_side_length;
snap_margin = (cell_width - snap_width) / 2; // 1.5mm
total_width = bin_width - wall_chamfer_outer*2;

cell_count = floor(bin_width / cell_width);

even_cell_count = (cell_count % 2 == 0) ? true : false;
snap_count = (even_cell_count) ? floor(cell_count / 2) : floor(cell_count / 2) + 1;
even_snap_count = (snap_count % 2 == 0) ? true : false;
gap_count = (even_cell_count) ? floor(cell_count / 2) - 1 : floor(cell_count/2);
gap_width = cell_width;

snap_remainder = bin_width - (cell_count * cell_width);
outer_snap_offset = even_cell_count ? (snap_remainder + cell_width)/2 : snap_remainder / 2;

module positioned_snaps() {
    for (i = [0 : snap_count - 1]) {
        translate([i * (cell_width * 2) + wall_chamfer_outer, snap_height, bin_height - cell_width])
            rotate([90, 0 , 0])
                opengrid_directional_snap();
    }
};

module positioned_bin() {
    translate([0, -bin_depth, -bin_height/2 + full_side_length])
        bin();
};

module positioned_dividers() {
    inner_width = bin_width - wall_thickness*(width_sub_bins-1);
    width_gap = inner_width / width_sub_bins;
    inner_depth = bin_depth - wall_thickness*2;
    depth_gap = inner_depth / depth_sub_bins;

    for (i = [1 : width_sub_bins - 1]) {
        translate([wall_thickness + width_gap*i - sub_bin_wall_thickness/2*i, 0, 0])
            rotate([0, 0, -90])
                bin_divider(length = bin_depth - wall_thickness/2);
    }
    
    for (i = [1 : depth_sub_bins - 1]) {
        translate([0, -wall_thickness - depth_gap*i - sub_bin_wall_thickness/2*i, 0])
            bin_divider(length = bin_width - wall_thickness/2);
    }
};

union() {
    positioned_bin();
    positioned_snaps();
    positioned_dividers();
};