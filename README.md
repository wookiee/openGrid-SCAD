# openGrid-SCAD
A collection of OpenSCAD drawings of parts for the openGrid organization wall platform

## Parts

#### openGrid Snap (Full)
This is a drawing of the full-thickness [openGrid Snap] for use as an ingredient in parts for the openGrid platform, such as the pegs and shelves below.

#### Parametric Peg
A single peg that sits perpendicular to the plane of the snap, with a small cap on the end.

The main user parameters are `peg_length` and `peg_diameter`.

The peg's diameter is The peg length is used as the distance length from the face of the snap to the bottom of the cap, which is 4mm thick and 4mm greater in diameter than the peg's diameter.

This model applies a fillet at the base of the peg, a fillet on both the top and bottom of the peg's cap, and a chamfer where the peg and the cap meet in order to prevent the need for supports when 3D printing.

#### Parametric Shelf
A peg with a configurable `shelf_width` and `shelf_depth`.

The shelf adds an inset lip around it to prevent objects from rolling/spilling off of it. Snaps are attached every other "cell width". That is, if you make your shelf 84mm wide (the width of 4 openGrid cells), the shelf will be generated with two snaps on he back, collectively centered on the back of the shelf.

#### Parametric Bin
My current work-in-progress project, not even alpha. Do not use. Under active development.

## License
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
Because these files remix and use designs from the openGrid platform, they adopt openGrid's selected [CC BY 4.0 License](https://creativecommons.org/licenses/by/4.0/).
