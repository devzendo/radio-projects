// Model by Matt M0CUV (c) 2025.

// All measurements in mm
element_gap = 8;
inter_element_height = 0.7;
wire_width = 2;
border = 3;
wall = 2;
gap = 6.35;

// this is actually 2 * (wire_width/2), but simplify that...
piece_width = element_gap + wire_width + (2*border);
piece_height = 1.25 * wire_width;

feeder_length = border + (gap/2) + 31.75;
enclosure_length = feeder_length + 10 + 15.31;
anti_gap = (piece_width/2)-(gap/2);
enclosure_height = 15 + border;
bnc_width = 9.5; // circluar threaded part
bnc_nut_max_width = 14.5;
// diameter of a cylinder around the bnc, giving enough space for the nut, and for it to be turned.
bnc_nut_cylinder = bnc_nut_max_width + 6 + wall;
// how much space should we give for bnc soldering?
bnc_nut_cylinder_length = 20 + wall;

union() {
    difference() {
        difference() {
            
            union() {
                // The enclosure box.
                color("blue")
                    cube([piece_width, enclosure_length, enclosure_height]);
                // cylinder in which the bnc can easily be fitted, with a few mil extra for tooling
                color("green")
                    rotate([-90, 0, 0])
                    translate([(piece_width/2), -(enclosure_height/2), enclosure_length - bnc_nut_cylinder_length])
                    cylinder(h=bnc_nut_cylinder_length, r=bnc_nut_cylinder/2, center=false, $fn = 360);
            }
            union() {
                // With the space inside removed.
                color("red")
                    translate([wall, wall, 0])
                    cube([piece_width - (2*wall), enclosure_length - (2*wall), enclosure_height - wall]);
                // the inside of the bnc cylinder is removed
                color("red")
                    rotate([-90, 0, 0])
                    translate([(piece_width/2), -(enclosure_height/2), enclosure_length - bnc_nut_cylinder_length])
                    cylinder(h=bnc_nut_cylinder_length - wall, r=(bnc_nut_cylinder/2) - wall, center=false, $fn = 360);

            }
        }
        
        union() {
            // Two wires
            color("yellow")
                // left
                rotate([-90, 0, 0])
                translate([(piece_width/2)-(element_gap/2), 0, 0])
                cylinder(h=feeder_length, r=wire_width/2, center=false, $fn = 360);
        
                // right
                rotate([-90, 0, 0])
                translate([(piece_width/2)+(element_gap/2), -0, 0])
                cylinder(h=feeder_length, r=wire_width/2, center=false, $fn = 360);
            
        
                // The insulation between the two wires    
                translate([(piece_width/2)-(element_gap/2), 0, 0])
                cube([element_gap, feeder_length, inter_element_height/2]);
            
                // The BNC socket
            color("red")
                rotate([-90, 0, 0])
                translate([(piece_width/2), -(enclosure_height/2), enclosure_length - wall])
                cylinder(h=wall*2, r=bnc_width/2, center=true, $fn = 360);
        }
    }
    
}

color("red")
// The flat part at the bottom of the BNC socket
rotate([-90, 0, 0])
    translate([border, -(enclosure_height/2) + 4, enclosure_length - wall])
    cube([bnc_width, 5, wall]);
 
