//
// Meccano ounting plate for 28BYJ-48 stepper motor
// 28BYJ-48 model after RGriffoGoes www.thingiverse.com/thing:204734
//
// V1.0 WH - May 12, 2018
// 
$fs=1;
$fa=0.5;
eps=0.05;

//
// Meccano constants
//
inch=25.4;
meccano_hole_spacing=0.500*inch;
meccano_hole_d=0.172*inch;

//
// flat_plate: create a standard Meccano sized flat plate
// x_holes: # of Meccano holes along the length (default: 7)
// y_holes: # of Meccano holes along the width (default: 5)
// elongate_end_holes: true to use elongated holes at both sides (default false)
// thickness: plate thickness (default: 0.1")
//
module flat_plate(thickness=0.100*inch,x_holes=7,y_holes=5,elongate_end_holes=false) {
  meccano_flat_plate_corner_r=0.250*inch;
  length=x_holes*meccano_hole_spacing;
  width=y_holes*meccano_hole_spacing;
  difference() {
    // plate
    hull() {
      translate([meccano_flat_plate_corner_r,meccano_flat_plate_corner_r,0])
        cylinder(h=thickness,r=meccano_flat_plate_corner_r);
      translate([length-meccano_flat_plate_corner_r,meccano_flat_plate_corner_r,0])
        cylinder(h=thickness,r=meccano_flat_plate_corner_r);
      translate([length-meccano_flat_plate_corner_r,width-meccano_flat_plate_corner_r,0])
        cylinder(h=thickness,r=meccano_flat_plate_corner_r);
      translate([meccano_flat_plate_corner_r,width-meccano_flat_plate_corner_r,0])
        cylinder(h=thickness,r=meccano_flat_plate_corner_r);
    }
    // Meccano holes
    for(x=[meccano_hole_spacing/2:meccano_hole_spacing:length]) {
      for(y=[meccano_hole_spacing/2:meccano_hole_spacing:width]) {
        if( elongate_end_holes && (x==meccano_hole_spacing/2 || x+meccano_hole_spacing>length) ) {
          translate([x,y,-eps])
            hull() {
              translate([-(0.250*inch-meccano_hole_d)/2,0,-eps])
                cylinder(h=thickness+2*eps,r=meccano_hole_d/2);
              translate([(0.250*inch-meccano_hole_d)/2,0,-eps])
                cylinder(h=thickness+2*eps,r=meccano_hole_d/2);
            }
        } else {
          translate([x,y,-eps])
            cylinder(h=thickness+2*eps,r=meccano_hole_d/2);
        }
      }
    }
  }
} // end module()

//
// mounting_plate_28BYJ: create a Meccano mounting plate for a 28BYJ stepper motor
// thickness: plate thickness (default: 0.1")
// x_holes: # of Meccano holes along the length (default: 7)
// y_holes: # of Meccano holes along the width (default: 5)
//
module mounting_plate_28BYJ(thickness=0.100*inch,x_holes=5,y_holes=4) {

  slop=0.25;
  body_h=18.8;                // motor body height
  body_d=28.5+slop;           // motor body OD
  shaft_boss_d=9.17+slop;     // shaft boss OD
  shaft_boss_h=1.53;          // shaft boss height above motor body
  shaft_y_offset=7.875;       // offset of shaft/boss center from motor center
  shaft_d=4.93+slop*2;        // motor shaft OD+ countersink for boss
  shaft_h=9.75;               // height of shaft above motor body 
  body_flange_h=0.9;          // height of body edge flange
  body_flange_w=1.7+slop;     // width of edge flange
  mounting_hole_spacing=35.2; // mounting hole center-to-center
  mounting_tab_h =0.8;        // mounting tab thickness
  mounting_tab_w =7.13+slop;  // mounting tab width
  mount_hole_d=3.0;           // mounting tab hole inner diameter
  box_h =16.7;                // plastic wiring box height
  box_w =14.7+slop;           // plastic wiring box width
  box_x =body_d/2+2.5;        // body diameter to outer surface of wiring box
  box2_h = box_h-1.7;
  box2_h_offset = 14.5;
  screw_head_d=5.2 + slop;    // M3 mounting screw head diameter
  screw_head_h=1.27;          // M3 screw head thickness (for countersink)
  screw_clearance_d=3.1+slop; // M3 screw diameter clearance hole

  //
  // StepMotor28BYJ: a slightly oversided model of the stepper motor for 
  // creating a mounting hole
  //
  module StepMotor28BYJ() {
    difference() {
      union() {
        color("silver")
         translate([0,0,-body_flange_h])
            difference() {
              cylinder(h=body_flange_h+eps, r=body_d/2,$fn=80);
              cylinder(h=body_flange_h+2*eps, r=(body_d-body_flange_w)/2,$fn=80);
            }
        color("silver")
          cylinder(h=body_h, r=body_d/2,$fn=80);
        color("goldenrod") translate([0,-shaft_y_offset,-shaft_boss_h])
          cylinder(h=shaft_boss_h+eps, r=shaft_boss_d/2);
        color("goldenrod") translate([0,-shaft_y_offset,-shaft_h])
          cylinder(h=shaft_h+eps, r=shaft_d/2);
        color("silver") translate([-mounting_hole_spacing/2,-mounting_tab_w/2,0])
          cube([mounting_hole_spacing,mounting_tab_w,mounting_tab_h+eps]);				
        color("silver") translate([mounting_hole_spacing/2,0,0])
          cylinder(h = mounting_tab_h+eps, r = mounting_tab_w/2);
        color("silver") translate([-mounting_hole_spacing/2,0,0])
          cylinder(h = mounting_tab_h+eps, r = mounting_tab_w/2);
        color("dodgerblue") translate([-box_w/2,0,eps])
          cube([box_w,box_x,box_h]);
        color("dodgerblue") translate([-(box_w+1)/2,0,box_h-box2_h_offset])
          cube([box_w+1,box_x-3,box2_h]);
      }
      translate([mounting_hole_spacing/2,0,-eps])	
        cylinder(h = mounting_tab_h+2*eps, r = mount_hole_d/2);
      translate([-mounting_hole_spacing/2,0,-eps])	
        cylinder(h = mounting_tab_h+2*eps, r = mount_hole_d/2);
    }
  } // end module()

  difference() {
    translate([-x_holes*meccano_hole_spacing/2,-y_holes*meccano_hole_spacing/2,0])
      union() {
        flat_plate(x_holes=x_holes,y_holes=y_holes,thickness=thickness);
        translate([(x_holes-3)/2*meccano_hole_spacing,meccano_hole_spacing,0])
          cube([3*meccano_hole_spacing,2*meccano_hole_spacing,thickness]);
        translate([(x_holes-1)/2*meccano_hole_spacing,3*meccano_hole_spacing,0])
          cube([meccano_hole_spacing,meccano_hole_spacing,thickness]);
      }
    // 28BYJ
    translate([0,shaft_y_offset-(y_holes-3)*meccano_hole_spacing/2,0])
      union() {
        translate([mounting_hole_spacing/2,0,-eps])
          cylinder(h=thickness+2*eps, r=screw_clearance_d/2);
        translate([-mounting_hole_spacing/2,0,-eps])
          cylinder(h=thickness+2*eps, r=screw_clearance_d/2);
        translate([mounting_hole_spacing/2,0,-eps])
          cylinder(h=screw_head_h+eps, r=screw_head_d/2);
        translate([-mounting_hole_spacing/2,0,-eps])  
          cylinder(h=screw_head_h+eps, r=screw_head_d/2);
        translate([0,0,thickness-mounting_tab_h/2])
          StepMotor28BYJ();
    }
  }
} // end module()

mounting_plate_28BYJ();
