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

// The battery dimensions (b_)
b_length = 43;
b_width = 30;
b_thick = 8;
// Battery holder is made of 2mm thick panels.
e_b_panel_thick = 2;
e_b_height = e_b_panel_thick + b_thick + e_b_panel_thick;

// Connector (c_) (N-Type, SMA)
c_diameter = 15.25; // N-Type
//c_diameter = 6; // SMA (need to measure this)
// If you want SMA, comment out the 'flat bits'

// Total height includes, at the top, the thickness of the
// screw fixings, and the lid itself.
e_total_height = e_thickness + e_h_height + e_b_height + e_thickness + e_thickness;

// M3 Nut/Screw mountings
nut_flat = 5.4;
nut_point_to_point = 6.16;
nut_hole = 2.95;
mnt_margin = 2;

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
    // The flat bits for the connector
    c_flat_bit_height = 1.16;
    translate([e_ext_length - (e_thickness), (e_ext_h_width / 2) - (c_diameter / 2), (e_total_height / 2) + (c_diameter / 2) - c_flat_bit_height])
        color("black")
        cube([e_thickness, 
              c_diameter,
              c_flat_bit_height
        ]);
    
    // The hook / barb that holds the board in place near the IPEX antenna connector.
    hk_length = 1.5;
    hk_width = 4;
    barb_length = 1;
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
        translate([e_thickness + h_length + h_ant_end_length - 5, midpoint_y + ipex_gap, e_thickness + h_screen_plus_pcb + 3])
            rotate([0, 45, 0])
            cube([hk_length + 2.5,
                hk_width,
                h_screen_plus_pcb + 2
            ]);
    }
    
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
    // Buttons
    but_x = 3.45; // centre point of buttons from LHS of board (seems too low; too left?)
    but_y = 3.45; // distance of centre point of buttons from edge of board (guessed)
    top_but_y = e_thickness + e_h_width_wiggle + h_width - but_y;
    bot_but_y = e_thickness + e_h_width_wiggle + but_y;
    color("black")
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
//        display_cutout();
//        button_holes();
//        usb_cutout();
//        n_type_connector_hole();
    }
}


// Render
main_enclosure();
