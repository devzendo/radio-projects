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
bnc_width = 9.5;

union() {
    difference() {
        difference() {
            // The enclosure box.
            color("blue")
                cube([piece_width, enclosure_length, enclosure_height]);
            color("red")
            // With the space inside removed.
                translate([wall, wall, 0])
                cube([piece_width - (2*wall), enclosure_length - (2*wall), enclosure_height - wall]);
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
 
