// An enclosure for a Heltec v3 LoRa board with optional
// header pins attached, optional small LiPo battery
// support, with a hole for a female N-Type antenna
// connector and pigtail.
//
// The screen of the Heltec is exposed, and two buttons
// are provided for control. The USB-C connector is also
// exposed on the side. The top screws on using
// countersunk M3 screws and nuts (these being embedded
// in the top edge).
//
// Not a "pretty" design, but functional, to be
// attached to a long grey 5.8dBi antenna and tied to
// the highest point in my loft. NOT WATERPROOF.
//
// 73 de Matt M0CUV

// Heltec (h_) dimensions. Include the header pins in
// h_total_height if your board has them.
// Dimensions annotated DS come from the datasheet.
h_header_pins_height = 5.8;
h_total_height = 10.2 + h_header_pins_height;
h_length = 50.2; // DS
h_width = 25.2; // DS
h_ant_end_length = 2.24; // length of the 'bay window' with the IPEX connector
h_margin = 3; // the width of the unused strip at the edge of the screen
h_visible_screen_length = 27.28; // DS
h_display_width = 18.56; // DS
h_screen = 5; // DS
h_screen_plus_pcb = h_screen + 1.64; // DS plus measured


// Enclosure dimensions (e_).
// The walls are mostly 3mm thick, although there are
// two ledges inside where the walls get thinner, to
// support the optional battery holder, and thinner
// again at the top, to support the lid.
pigtail_gap = 59; // make the case longer by increasing
// The pigtail I had was 2" - 36 gave some fitting room.
e_thickness = 3;
e_ext_length = e_thickness + h_length + pigtail_gap + e_thickness;
// At the base, where the Heltec mounts...
// Give a little room either side of the board
e_h_width_wiggle = 1;
e_ext_h_width = e_thickness + e_h_width_wiggle + h_width + e_h_width_wiggle + e_thickness;
midpoint_y = e_ext_h_width / 2;
// Above the Heltec the walls thin out by 1mm to ledge the
// battery holder. How high is the Heltec bottom compartment?
e_h_height = h_total_height;


// Buttons
but_x = 3.45; // centre point of buttons from LHS of board (seems too low; too left?)
but_y = 3.45; // distance of centre point of buttons from edge of board (guessed)
top_but_y = e_thickness + e_h_width_wiggle + h_width - but_y;
bot_but_y = e_thickness + e_h_width_wiggle + but_y;



// The battery dimensions (b_)
b_length = 43;
b_width = 30;
b_thick = 8;
// Battery holder is made of 2mm thick panels.
e_b_panel_thick = 2;
e_b_height = e_b_panel_thick + b_thick + e_b_panel_thick;

// Battery holder
bh_length = 47;
bh_height = e_ext_h_width - (2*e_thickness) + 2;


// Connector (c_) (N-Type, SMA)
c_diameter = 15.75; // N-Type
//c_diameter = 6; // SMA (need to measure this)
// If you want SMA, comment out the 'flat bits'

// Total height includes, at the top, the thickness of the
// screw fixings, and the lid itself.
e_total_height = e_thickness + e_h_height + e_b_height + e_thickness + e_thickness;

// M3 Nut/Screw mountings
nut_flat = 5.4;
nut_point_to_point = 6.16;
nut_hole = 2.95;
nut_height = 2.4;
mnt_margin = 2;
head_diameter = 6.0; // countersunk head diameter (top)
head_height = 1.65;  // countersunk head height
screw_length = 6;
shaft_length = screw_length - head_height;

// Modules

module screw_mounting() {
    difference() {
        // mounting bracket
        color("red")
        cube([mnt_margin + nut_point_to_point + mnt_margin, 
            mnt_margin + nut_flat + mnt_margin,
            e_thickness
        ]);
        union() {
            // screw thread
            color("yellow")
            translate([(mnt_margin + nut_point_to_point + mnt_margin)/2, (mnt_margin + nut_flat + mnt_margin)/2, 0])
                cylinder($fa=1, h=e_thickness*2, r=nut_hole/2, center=true, $fn = 360);
            // nut
            color("blue")
            translate([(mnt_margin + nut_point_to_point + mnt_margin)/2, (mnt_margin + nut_flat + mnt_margin)/2, e_thickness - nut_height])
                cylinder(h=nut_height, d=nut_flat/cos(30), $fn=6);
        }
    }

}

// The whole enclosure:
module enclosure_body() {
    difference() {
        // Outer shell
        color("blue")
        cube([e_ext_length, e_ext_h_width, e_total_height]);
        
        // Hollow interior
        translate([e_thickness, e_thickness, e_thickness])
            color("green")
            cube([e_ext_length - (2*e_thickness), 
                  e_ext_h_width - (2*e_thickness),
                  e_total_height // stick out the top
        ]);

        // Hollow interior - narrower for battery holder
        translate([e_thickness, e_thickness-1, e_thickness+e_h_height])
            color("red")
            cube([e_ext_length - (2*e_thickness), 
                  e_ext_h_width - (2*e_thickness) + 2,
                  e_total_height // stick out the top
        ]);
        
        // Top opening with lip for removable top
        translate([e_thickness, e_thickness-2, e_thickness+e_h_height+e_b_height])
            color("yellow")
            cube([e_ext_length - (2*e_thickness), 
                  e_ext_h_width - (2*e_thickness) + 4,
                  e_total_height // stick out the top
        ]);
        
        // The hole for the antenna connector.
        translate([e_ext_length - (e_thickness / 2), e_ext_h_width / 2, e_total_height / 2])
            color("black")
            // Hole
            {
                rotate([0, 90, 0])
                cylinder($fa=1, h=e_thickness*2, r=c_diameter/2, center=true, $fn = 360);
            }
    }
    // The flat bits for the antenna connector
    c_flat_bit_height = 1.16;
    c_flat_bit_z_wiggle = 0.5;
    translate([e_ext_length - (e_thickness), (e_ext_h_width / 2) - (c_diameter / 2), (e_total_height / 2) + (c_diameter / 2) - c_flat_bit_height + c_flat_bit_z_wiggle])
        color("black")
        cube([e_thickness, 
              c_diameter,
              c_flat_bit_height
        ]);
    
    // The hook / barb that holds the board in place near the IPEX antenna connector.
    hk_length = 2.0;
    hk_width = 4;
    barb_length = 0.5;
    // 3 roughly how much space away from the midpoint of the IPEX
    ipex_gap = 3;
    // A cube with a 45 degree rotated cube removed, for the hook.
    // Some empirical faffery going on here!
    difference() {
        // vertical and cube
        union() {
            // vertical
            translate([e_thickness + h_length + h_ant_end_length, midpoint_y + ipex_gap, e_thickness])
            cube([hk_length, 
                hk_width,
                h_screen_plus_pcb + 4
            ]);
            // cube
            translate([e_thickness + h_length + h_ant_end_length - barb_length, midpoint_y + ipex_gap, e_thickness + h_screen_plus_pcb])
                cube([hk_length + barb_length, 
                    hk_width,
                    h_screen_plus_pcb
                ]);
        }
        // take off a triangular prism
        color("red")
        translate([e_thickness + h_length + h_ant_end_length - 5, midpoint_y + ipex_gap, e_thickness + h_screen_plus_pcb + 1.5])
            rotate([0, 30, 0])
            cube([hk_length + 2.5,
                hk_width,
                h_screen_plus_pcb + 2
            ]);
    }
    // A 'wall' that holds the board end (where the IPEX connector is) in place.
    wa_width = 10.5;
    wa_length = e_thickness - 1;
    wa_height = h_screen_plus_pcb + 0.5; // just taller than PCB
    translate([e_thickness + h_length + h_ant_end_length, (midpoint_y/2)+(wa_width/2), e_thickness])
        cube([wa_length, wa_width, wa_height]);
    
    // The screw mountings
    translate([e_thickness, 1, e_total_height - (2 * e_thickness)])
    screw_mounting();
    translate([e_thickness, e_ext_h_width - 1 - (mnt_margin * 2 + nut_flat), e_total_height - (2 * e_thickness)])
    screw_mounting();
    translate([e_ext_length - e_thickness - (mnt_margin + nut_point_to_point + mnt_margin), 1, e_total_height - (2 * e_thickness)])
    screw_mounting();
    translate([e_ext_length - e_thickness - (mnt_margin + nut_point_to_point + mnt_margin), e_ext_h_width - 1 - (mnt_margin * 2 + nut_flat), e_total_height - (2 * e_thickness)])
    screw_mounting();
}

module heltec_cutouts() {
    color("red")
    union() {
        // Display cutout
        left_display = (h_length - h_ant_end_length - h_margin - h_visible_screen_length);
        // board_x here is the position of the cutout for the board / USBC
        board_x = 1;
        translate([board_x + left_display, (e_ext_h_width/2)-(h_display_width/2), 0])
            cube([h_visible_screen_length, 
                  h_display_width,
                  e_thickness
        ]);
    
        // Top button thick restraint
        translate([board_x + but_x, top_but_y, e_thickness - (e_thickness/4)])
            cylinder($fa=1, h=e_thickness/2, r=3, center=true, $fn = 360);
        // Top button button hole
        translate([board_x + but_x, top_but_y, (e_thickness/4)])
            cylinder($fa=1, h=e_thickness/2, r=2, center=true, $fn = 360);
        // Bottom button thick restraint
        translate([board_x + but_x, bot_but_y, e_thickness - (e_thickness/4)])
            cylinder($fa=1, h=e_thickness/2, r=3, center=true, $fn = 360);
        // Bottom button button hole
        translate([board_x + but_x, bot_but_y, (e_thickness/4)])
            cylinder($fa=1, h=e_thickness/2, r=2, center=true, $fn = 360);
            

        // Board cuts into the enclosure by 2mm to secure it, but beware there are
        // components on it, so have some cutouts where they are so we don't damage
        // them.
        translate([board_x, e_thickness, e_thickness])
            cube([e_thickness - board_x, 
                  e_ext_h_width - (2*e_thickness),
                  h_screen_plus_pcb
        ]);
        // Component cutout on the right hand side of the power connector
        comp_y_offset = 16.5; // measured
        comp_width = 7; // measured
        comp_height = 2; // just to make sure
        translate([board_x, e_thickness + e_h_width_wiggle + comp_y_offset, e_thickness + h_screen_plus_pcb])
            cube([e_thickness - board_x, comp_width, comp_height]);

        // LEDs
        led_x = 8.2; // measured
        led_1_y = 3.1; // measured
        led_2_y = 5.5; // measured
        translate([board_x + led_x, e_thickness + e_h_width_wiggle + led_1_y, e_thickness/2])
            cylinder($fa=1, h=e_thickness, r=0.75, center=true, $fn=360);
        translate([board_x + led_x, e_thickness + e_h_width_wiggle + led_2_y, e_thickness/2])
            cylinder($fa=1, h=e_thickness, r=0.75, center=true, $fn=360);
            
        // The WiFi/BLE antenna (diam. 4mm) needs a bit of space. 
        translate([e_thickness + 11.5, bot_but_y + 1, e_thickness - ((e_thickness/4))])
            cylinder($fa=1, h=e_thickness/1.3, r=3.25, center=true, $fn = 360);

        // USB-C https://fyozdiwwu.blob.core.windows.net/dimensions-of-usb-connector.html
        u_width = 8.34;
        u_height = 3.16;

        translate([0, midpoint_y - (u_width / 2), e_thickness + h_screen - (u_height / 2)])
            rotate([0, 90, 0])
            cylinder($fa=1, h=e_thickness, r=u_height/2, center=true, $fn = 360);
        translate([0, midpoint_y + (u_width / 2), e_thickness + h_screen - (u_height / 2)])
            rotate([0, 90, 0])
            cylinder($fa=1, h=e_thickness, r=u_height/2, center=true, $fn = 360);

        translate([0, midpoint_y - (u_width / 2), e_thickness + h_screen - u_height])
            cube([e_thickness,
                  u_width,
                  u_height
        ]);


    }
}


module main_enclosure() {
    difference() {
        enclosure_body();
        heltec_cutouts();
    }
}

module battery_holder() {
    y_offset = e_ext_h_width + 10;
    mounting_gap = 2;
    // bottom short part
    translate([20, y_offset, 0])
        cube([27, 2, bh_height]);
    // vertical part
    translate([45, y_offset + 2, 0])
        cube([2, 8, bh_height]);
    // top long part with screw mountings cut out
    difference() {
        translate([0, y_offset + 10, 0])
            cube([bh_length, 2, bh_height]);
        color("red")
        // two cutouts
        union() {
            translate([0, y_offset + 10, 0])
                cube([mnt_margin + nut_point_to_point + mnt_margin + mounting_gap,
                    2,
                    mnt_margin + nut_flat + mnt_margin + mounting_gap]);
            translate([0, y_offset + 10, bh_height - (mnt_margin + nut_flat + mnt_margin + mounting_gap)])
                cube([mnt_margin + nut_point_to_point + mnt_margin + mounting_gap,
                    2,
                    mnt_margin + nut_flat + mnt_margin + mounting_gap]);
        }        
    }
}

module buttons() {
    y_offset = e_ext_h_width + 10;
    x_offset = e_ext_h_width - (2*e_thickness) + 2 + 20; // 20mm from the battery
    
    wiggle = 0.2;
    sep = top_but_y - bot_but_y;
    
    // Top button thick restraint
    translate([x_offset, y_offset, e_thickness/4])
        cylinder($fa=1, h=e_thickness/2, r=3 - wiggle, center=true, $fn = 360);

    // Top button button hole
    translate([x_offset, y_offset, e_thickness + (e_thickness/2)])
        cylinder($fa=1, h=e_thickness*2, r=2 - wiggle, center=true, $fn = 360);
    
    // Bottom button thick restraint
    translate([x_offset + sep, y_offset, e_thickness/4])
        cylinder($fa=1, h=e_thickness/2, r=3 - wiggle, center=true, $fn = 360);

    // Bottom button button hole
    translate([x_offset + sep, y_offset, e_thickness + (e_thickness/2)])
        cylinder($fa=1, h=e_thickness*2, r=2 - wiggle, center=true, $fn = 360);
        
    // Connecting strip (omit for now)
//    translate([x_offset, y_offset, 0])
//        cube([sep, 3 - wiggle, 1]);
}

module countersunk_screw() {
    color("yellow")
    translate([(mnt_margin + nut_point_to_point + mnt_margin)/2, (mnt_margin + nut_flat + mnt_margin)/2, 0])
    union() {
        // Conical countersunk head
        cylinder(h=head_height, d1=head_diameter, d2=nut_hole, $fn=30);
    
        // Cylindrical shaft
        translate([0, 0, e_thickness])
            cylinder($fa=1, h=e_thickness*2, r=nut_hole/2, center=true, $fn = 360);
    }
}

module lid() {
    y_offset = e_ext_h_width + 30;
    restraint_length = 10;
    color("blue")
    difference() {
        union () {
            // lid plate
            translate([e_thickness, y_offset, 0])
                cube([e_ext_length - (2*e_thickness), e_ext_h_width - 2, e_thickness]);
            // battery holder restraint
            translate([e_thickness + bh_length - (restraint_length / 2), y_offset, e_thickness])
                cube([restraint_length, e_ext_h_width - 2, e_thickness]);
            translate([e_thickness + bh_length, y_offset, e_thickness * 2])
                cube([restraint_length / 2, e_ext_h_width - 2, e_thickness]);
        }

        // countersunk screws
        union() {
            translate([e_thickness, y_offset + 1, 0])
                countersunk_screw();
            translate([e_thickness, y_offset + e_ext_h_width - 1 - (mnt_margin * 2 + nut_flat), 0])
                countersunk_screw();
            translate([e_ext_length - e_thickness - (mnt_margin + nut_point_to_point + mnt_margin), y_offset + 1, 0])
                countersunk_screw();
        translate([e_ext_length - e_thickness - (mnt_margin + nut_point_to_point + mnt_margin), y_offset + e_ext_h_width - 1 - (mnt_margin * 2 + nut_flat), 0])
                countersunk_screw();

        }
    }
}

// Render

main_enclosure();

rotate([0, 90, 0])
translate([-47, 0, 0])
battery_holder();

buttons();

lid();
