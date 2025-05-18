// Model by Matt M0CUV (c) 2025.

// All measurements in mm
element_gap = 8;
inter_element_height = 0.7;
wire_width = 2;
border = 3;
gap = 6.35;

// this is actually 2 * (wire_width/2), but simplify that...
piece_width = element_gap + wire_width + (2*border);
piece_height = 1.25 * wire_width;

anti_gap = (piece_width/2)-(gap/2);

union() {
    difference() {
        // The top mount/cable fix.
        color("blue")
            cube([piece_width, piece_width,  piece_height]);
    
        
        union() {
            // Two wires
            color("yellow")
                // The one throughout
                rotate([-90, 0, 0])
                translate([(piece_width/2)-(element_gap/2), -piece_height, 0])
                cylinder(h=piece_width, r=wire_width/2, center=false, $fn = 360);
        
                // The top and bottom with the gap
                // top
                rotate([-90, 0, 0])
                translate([(piece_width/2)+(element_gap/2), -piece_height, piece_width-anti_gap])
                cylinder(h=anti_gap, r=wire_width/2, center=false, $fn = 360);
                // bottom
                rotate([-90, 0, 0])
                translate([(piece_width/2)+(element_gap/2), -piece_height, 0])
                cylinder(h=anti_gap, r=wire_width/2, center=false, $fn = 360);
        
            // The insulation between the two wires    
            color("red")    
                translate([(piece_width/2)-(element_gap/2), 0, piece_height-(   inter_element_height/2)])
                cube([element_gap, piece_width, inter_element_height/2]);
        }
    }
    
    // The cylinder that goes through the cable to hold it.
    color("pink")
        translate([(piece_width/2), (piece_width/2), 0])
        cylinder(h=piece_height, r=element_gap/6, center=false, $fn = 360);
}
    
    
    
