// Model by Matt M0CUV (c) 2025.

// All measurements in mm
element_gap = 8;
inter_element_height = 0.7;
wire_width = 2;
border = 3;

// this is actually 2 * (wire_width/2), but simplify that...
piece_width = element_gap + wire_width + (2*border);
piece_height = 1.25 * wire_width;

union() {
    difference() {
        union() {
            // The top mount/cable fix.
            color("blue")
                cube([piece_width, piece_width,  piece_height]);
    
            difference() {
                // The hook
                color("green")
                    translate([(piece_width/2), piece_width, 0])
                    cylinder(h=piece_height, r=piece_width/2, center=false, $fn = 360);
                // The hole
                color("white")
                    translate([(piece_width/2), piece_width, 0])
                    cylinder(h=piece_height, r=piece_width/3, center=false, $fn = 360);
            }
        }
        
        union() {
            // Two wires
            color("yellow")
                rotate([-90, 0, 0])
                translate([(piece_width/2)-(element_gap/2), -piece_height, 0])
                cylinder(h=piece_width*(2/3), r=wire_width/2, center=false, $fn = 360);
        
                rotate([-90, 0, 0])
                translate([(piece_width/2)+(element_gap/2), -piece_height, 0])
                cylinder(h=piece_width*(2/3), r=wire_width/2, center=false, $fn = 360);
        
            // The insulation between the two wires    
            color("red")    
                translate([(piece_width/2)-(element_gap/2), 0, piece_height-(   inter_element_height/2)])
                cube([element_gap, piece_width*(2/3), inter_element_height/2]);
        }
    }
    
    // The cylinder that goes through the cable to hold it.
    color("pink")
        translate([(piece_width/2), (piece_width/3), 0])
        cylinder(h=piece_height, r=element_gap/6, center=false, $fn = 360);
}