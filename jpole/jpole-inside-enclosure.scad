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

union() {
    difference() {
        // The top mount/cable fix.
        color("blue")
            cube([piece_width, feeder_length + border, piece_height]);
    
        
        union() {
            // Two wires
            color("yellow")
                // left
                rotate([-90, 0, 0])
                translate([(piece_width/2)-(element_gap/2), -piece_height, 0])
                cylinder(h=feeder_length, r=wire_width/2, center=false, $fn = 360);
        
                // right
                rotate([-90, 0, 0])
                translate([(piece_width/2)+(element_gap/2), -piece_height, 0])
                cylinder(h=feeder_length, r=wire_width/2, center=false, $fn = 360);
            
                // Gap at the end of the wires where they connect
                rotate([0, 90, 0])
                translate([-piece_height, feeder_length, border])
                cylinder(h=element_gap + wire_width, r=wire_width/2, center=false, $fn = 360);

                // space for connecting the coax - cuts off the end nearest the feeder input
                // so the case-enclosure fits over the top properly, and allows access to
                // connect the coax.
                // was this: a nice hole through, allowing some access - but occluded the 
                // case-enclosure.
                // translate([border, border, 0])
                // cube([element_gap + wire_width, gap, piece_height]);
                translate([0, 0, 0])
                cube([piece_width, border + gap, piece_height]);

            // The insulation between the two wires    
            color("red")    
                translate([(piece_width/2)-(element_gap/2), 0, piece_height-(   inter_element_height/2)])
                cube([element_gap, feeder_length, inter_element_height/2]);
                
            // Cut a bit off each side all the way along so it'll fit in the enclosure

        color("red")
            cube([wall+0.5, feeder_length + border, piece_height]);
        color("red")
            translate([piece_width-(wall+0.5), 0, 0])
            cube([wall+0.5, feeder_length + border, piece_height]);
            
        }
    }
    
    // The cylinder that goes through the cable to hold it.
    color("pink")
        translate([(piece_width/2), (feeder_length/2), 0])
        cylinder(h=piece_height, r=element_gap/6, center=false, $fn = 360);
}
//color("purple")
//                translate([0, 0, 0])
//                cube([piece_width, border + gap, piece_height]);
