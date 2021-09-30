//
// pn 606 relay mounting plate
//
// Dimensions taken from original Meccano blueprint shown at:
// https://www.meccanoindex.co.uk/Drawings/Jdisp.php?Jpart=23306&id=1523075675
//
// Probably only useful if you have a broken relay mounting plate,
// or as a starting point to create a custom mounting plate for a
// relay that you've bought yourself. Similar relays are 
// (apparently) still available from the likely original supplier
// to Meccano (Varley Keyswitch), as indicated in this Rust Bucket
// thread:
//
// http://www.nzmeccano.com/forum/showthread.php?tid=2283
//
// V1.0 - April 7 2018 WH
//
$fn=30;
inch=25.4;

base_width=2.000*inch;
base_depth=1.191*inch;
base_thick=0.110*inch;
base_corner_rad=1/8*inch;
mnt_hole_rad=0.156/2*inch;
base_mnt_back_y=base_depth-0.346*inch;
base_mnt_front_y=base_mnt_back_y-0.500*inch;
base_mnt_left_x=0.250*inch;
base_mnt_right_x=base_width-base_mnt_left_x;

centre_base_x=base_width/2;

rmnt_width=1.125*inch;
rmnt_depth=0.875*inch;
rmnt_thick=0.219*inch;
rmnt_corner_rad=0.093*inch;

centre_rmnt_x=rmnt_width/2;

rmnt_cutout_width=0.845*inch;
rmnt_cutout_depth=rmnt_depth-base_thick-0.109*inch;
rmnt_cutout_thick=rmnt_thick-0.125*inch;

hole_1_x=centre_rmnt_x+0.331*inch;
hole_1_y=base_thick+0.536*inch;
hole_1_rad=0.135/2*inch;
hole_1_surr_rad=0.093*inch;

hole_2_x=hole_1_x;
hole_2_y=base_thick+0.173*inch;
hole_2_rad=hole_1_rad;
hole_2_surr_rad=hole_1_surr_rad;
hole_2_surr_support=0.25*inch;

hole_3_x=centre_rmnt_x-0.109*inch;
hole_3_y=base_thick+0.556*inch;
hole_3_inner_rad=0.130/2*inch;
hole_3_outer_rad=0.218/2*inch;
hole_3_surr_rad=0.141*inch;
hole_3_offset=0.031*inch;

hole_4_x=centre_rmnt_x-0.406*inch;
hole_4_y=hole_3_y;
hole_4_inner_rad=0.130/2*inch;
hole_4_outer_rad=0.218/2*inch;
hole_4_surr_rad=hole_3_surr_rad;
hole_4_offset=hole_3_offset;

hole_5_x=centre_rmnt_x-0.241*inch;
hole_5_y=base_thick+0.359*inch;
hole_5_rad=0.130/2*inch;
hole_5_surr_rad=0.093*inch;

support_depth=0.188*inch;
support_width=(rmnt_width-0.980*inch)/2;
support_height=0.125*inch;

score_width=0.005*inch;
score_height=0.005*inch;
score_spacing=0.703*inch;
score_length=0.965*inch;

guide_line_height=0.010*inch;   // you will need a very fine nozzle for
guide_line_width=0.010*inch;    // these lines to actually be printed

module relay()
{
   difference() {
      union() {
         // base plate
         hull() {
            translate([base_corner_rad,base_corner_rad,0]) 
               cylinder(h=base_thick,r=base_corner_rad);
            translate([base_width-base_corner_rad,base_corner_rad,0]) 
               cylinder(h=base_thick,r=base_corner_rad);
            translate([base_corner_rad,base_depth-base_corner_rad,0]) 
               cylinder(h=base_thick,r=base_corner_rad);
            translate([base_width-base_corner_rad,base_depth-base_corner_rad,0])
               cylinder(h=base_thick,r=base_corner_rad);
         }
         // relay mounting plate
         translate([centre_base_x-rmnt_width/2,base_depth+rmnt_thick,0])
            rotate([90,0,0])
               difference() {
                  union() {
                     difference() {
                        hull() {
                           cube(rmnt_thick);
                           translate([rmnt_width-rmnt_thick,,0]) cube(rmnt_thick);
                           translate([rmnt_corner_rad,rmnt_depth-rmnt_corner_rad,0])
                              cylinder(h=rmnt_thick,r=rmnt_corner_rad);
                           translate([rmnt_width-rmnt_corner_rad,rmnt_depth-rmnt_corner_rad,0])
                              cylinder(h=rmnt_thick,r=rmnt_corner_rad);
                        }
                        // relay mounting plate cutout
                        translate([(rmnt_width-rmnt_cutout_width)/2,base_thick,rmnt_thick-rmnt_cutout_thick])
                           cube([rmnt_cutout_width,rmnt_cutout_depth,rmnt_cutout_thick]);
                     }
                     // relay hole surrounds
                     //
                     // hole 1 surround
                     hull() {	
                        translate([hole_1_x,hole_1_y,0])
                           cylinder(h=rmnt_thick,r=hole_1_surr_rad);
                        translate([hole_1_x-hole_1_surr_rad,rmnt_depth-1,0])
                           cube([1,1,rmnt_thick]);
                        translate([rmnt_width-rmnt_corner_rad,rmnt_depth-rmnt_corner_rad,0])
                           cylinder(h=rmnt_thick,r=rmnt_corner_rad);
                        translate([rmnt_width-1,hole_1_y-hole_1_surr_rad,0])
                           cube([1,1,rmnt_thick]);
                     }
                     // hole 2 surround
                     hull() {	
                        translate([hole_2_x,hole_2_y,0])
                           cylinder(h=rmnt_thick,r=hole_2_surr_rad);
                        translate([rmnt_width-1,hole_2_y-hole_2_surr_rad,0])
                           cube([1,hole_2_surr_rad*2,rmnt_thick]);
                     }
                     translate([rmnt_width-hole_2_surr_support,0,0])
                        cube([hole_2_surr_support,hole_2_y,rmnt_thick]);
                     // hole 3 & 4 surround
                     hull() {	
                        translate([hole_3_x,hole_3_y,0])
                           cylinder(h=rmnt_thick,r=hole_3_surr_rad);
                        translate([0,hole_3_y-hole_3_surr_rad,0])
                           cube([1,1,rmnt_thick]);
                        translate([rmnt_corner_rad,rmnt_depth-rmnt_corner_rad,0])
                           cylinder(h=rmnt_thick,r=rmnt_corner_rad);
                        translate([hole_3_x+hole_3_surr_rad-1,rmnt_depth-1,0])
                           cube([1,1,rmnt_thick]);
                     }
                     // hole 5 surround
                     hull() {	
                        translate([hole_5_x,hole_5_y,0])
                           cylinder(h=rmnt_thick,r=hole_5_surr_rad);
                        translate([hole_5_x-hole_2_surr_rad,rmnt_depth-1,0])
                           cube([hole_5_surr_rad*2,1,rmnt_thick]);
                     }
                  }
                  // relay holes
                  translate([hole_1_x,hole_1_y,0])
                     intersection() {
                        cylinder(h=rmnt_thick,r=hole_1_rad);
                        linear_extrude(h=rmnt_thick)
                           polygon([
                              [-hole_1_rad,-hole_1_rad*0.9],
                              [-hole_1_rad, hole_1_rad],
                              [ hole_1_rad, hole_1_rad],
                              [ hole_1_rad,-hole_1_rad*0.9],
                              [-hole_1_rad,-hole_1_rad*0.9]]);
                        }
                  translate([hole_2_x,hole_2_y,0])
                     intersection() {
                        cylinder(h=rmnt_thick,r=hole_2_rad);
                        linear_extrude(h=rmnt_thick)
                           polygon([
                              [-hole_2_rad,-hole_2_rad],
                              [-hole_2_rad, hole_2_rad*0.9],
                              [ hole_2_rad, hole_2_rad*0.9],
                              [ hole_2_rad,-hole_2_rad],
                              [-hole_2_rad,-hole_2_rad]]);
                        }
                  translate([hole_3_x,hole_3_y,0])
                     difference() {
                        union() {
                           cylinder(h=rmnt_thick,r=hole_3_inner_rad);
                           translate([0,0,hole_3_offset])
                              cylinder(h=rmnt_thick-hole_3_offset,r=hole_3_outer_rad);
                        }
                        rotate([0,0,45])
                           translate([-hole_3_outer_rad,0,hole_3_offset])
                              cube([guide_line_width,guide_line_width,rmnt_thick-hole_3_offset]);
                        rotate([0,0,-45])
                           translate([-hole_3_outer_rad,0,hole_3_offset])
                              cube([guide_line_width,guide_line_width,rmnt_thick-hole_3_offset]);
                     }
                  translate([hole_4_x,hole_4_y,0])
                     difference() {
                        union() {
                           cylinder(h=rmnt_thick,r=hole_4_inner_rad);
                           translate([0,0,hole_4_offset])
                              cylinder(h=rmnt_thick-hole_4_offset,r=hole_4_outer_rad);
                        }
                        rotate([0,0,45])
                           translate([hole_4_outer_rad-guide_line_width,0,hole_4_offset])
                              cube([guide_line_width,guide_line_width,rmnt_thick-hole_4_offset]);
                        rotate([0,0,-45])
                           translate([hole_4_outer_rad-guide_line_width,0,hole_4_offset])
                              cube([guide_line_width,guide_line_width,rmnt_thick-hole_4_offset]);
                     }
                  translate([hole_5_x,hole_5_y,0])
                     intersection() {
                        cylinder(h=rmnt_thick,r=hole_5_rad);
                        linear_extrude(h=rmnt_thick)
                           polygon([
                              [-hole_5_rad*0.9,-hole_5_rad],
                              [-hole_5_rad*0.9, hole_5_rad],
                              [ hole_5_rad,     hole_5_rad],
                              [ hole_5_rad,    -hole_5_rad],
                              [-hole_5_rad*0.9,-hole_5_rad]]);
                        }
               }
         translate([centre_base_x-rmnt_width/2+support_width,base_depth,base_thick])
            rotate([0,0,-1])
               translate([0,-support_depth,0])
               rotate([0,-90,0])
                  linear_extrude(support_width)
                     polygon([[0,0],[0,support_depth],[support_height,support_depth],[0,0]]);
         translate([centre_base_x+rmnt_width/2,base_depth,base_thick])
            rotate([0,0,1])
               translate([0,-support_depth,0])
               rotate([0,-90,0])
                  linear_extrude(support_width)
                     polygon([[0,0],[0,support_depth],[support_height,support_depth],[0,0]]);
      }
      // base plate mounting holes
      translate([base_mnt_left_x,base_mnt_front_y,0])
         cylinder(h=base_thick,r=mnt_hole_rad);
      translate([base_mnt_right_x,base_mnt_front_y,0])
         cylinder(h=base_thick,r=mnt_hole_rad);
      translate([base_mnt_left_x,base_mnt_back_y,0])
         cylinder(h=base_thick,r=mnt_hole_rad);
      translate([base_mnt_right_x,base_mnt_back_y,0])
         cylinder(h=base_thick,r=mnt_hole_rad);
      // score lines
      translate([centre_base_x-score_spacing/2,base_depth-score_length,base_thick-score_height])
         cube([score_width,score_length,score_height]);
      translate([centre_base_x+score_spacing/2,base_depth-score_length,base_thick-score_height])
         cube([score_width,score_length,score_height]);
   }
}
//
// print with the relay base down as it has detail that wouldn't
// print well if things were printed with the Meccano base down
//
translate([base_width,rmnt_depth,base_depth+rmnt_thick])
   rotate([-90,0,180])
      relay(); 
