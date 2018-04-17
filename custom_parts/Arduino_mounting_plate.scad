//
// Arduino_mounting_plate: create a mounting adapter for an
// Arduino Uno and standard Meccano hole spacing.
//
// V1.0 - April 16, 2018 WH - the quick and dirty version
//
$fn=40;

inch=25.4;

//
// Meccano constants
//
meccano_hole_spacing=0.500*inch;
meccano_hole_d=0.172*inch;

function uno_length() = 2.7*inch; // length of Arduino Uno board
function uno_width() = 2.1*inch;  // and the width

uno_hole_locations = [		// Arduino Uno
  [0.55*inch,0.10*inch],	// mounting hole
  [2.60*inch,0.30*inch],	// locations
  [2.60*inch,1.40*inch],
  [0.60*inch,2.00*inch]
];

//
// uno_holes: create standard sized holes to mount an
// Arduino Uno
//
module uno_holes(thickness,dia=0.125*inch) {
  translate(uno_hole_locations[0])
    cylinder(h=thickness,r=dia/2);
  translate(uno_hole_locations[1])
    cylinder(h=thickness,r=dia/2);
  translate(uno_hole_locations[2])
    cylinder(h=thickness,r=dia/2);
  translate(uno_hole_locations[3])
    cylinder(h=thickness,r=dia/2);
}

//
// uno_standoffs: create standoffs for an Arduino Uno PCB. This
// module accounts for the limited space available around the
// upper left standoff.
//
// height: standoff height
// dia: standoff dia (default 0.250")
//
module uno_standoffs(height,dia=0.250*inch) {
  // the upper left mounting hole has very restricted
  // real estate on the bottom and right side, so we
  // need to notch the standoff
  ul_hole_notch_height=0.060*inch;
  r_notch_width=0.100*inch;
  r_notch_offset=(0.125/2+0.030)*inch;
  b_notch_width=0.100*inch;
  b_notch_offset=(-0.125/2-0.030)*inch-b_notch_width;
  ul_hole_x=uno_hole_locations[3][0];
  ul_hole_y=uno_hole_locations[3][1];

  difference() {
    uno_holes(height,dia);
    translate([ul_hole_x+r_notch_offset,ul_hole_y-dia/2,height-ul_hole_notch_height])
      cube([r_notch_width,dia,ul_hole_notch_height]);
    translate([ul_hole_x-dia/2,ul_hole_y+b_notch_offset,height-ul_hole_notch_height])
      cube([dia,b_notch_width,ul_hole_notch_height]);
  }
}

//
// uno: create a flat plate in the shape of an Arduino Uno
//
// thickness: plate thickness (default 1.5mm)
//
module uno(thickness=1.5) {
  difference() {
    linear_extrude(height=thickness)
      polygon([
        [0,0],
        [2.60*inch,0],
        [2.60*inch,0.10*inch],
        [2.70*inch,0.20*inch],
        [2.70*inch,1.49*inch],
        [2.60*inch,1.59*inch],
        [2.60*inch,2.04*inch],
        [2.54*inch,2.10*inch],
        [0,2.1*inch],
        [0,0]
      ]);
    uno_holes(thickness);
  }
}

//
// flate_plate: create a standard Meccano sized flat plate
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
    for(x=[meccano_hole_spacing/2:meccano_hole_spacing:length]) {
      for(y=[meccano_hole_spacing/2:meccano_hole_spacing:width]) {
        if( elongate_end_holes && (x==meccano_hole_spacing/2 || x+meccano_hole_spacing>length) ) {
          translate([x,y,0])
            hull() {
              translate([-(0.250*inch-meccano_hole_d)/2,0,0])
                cylinder(h=thickness,r=meccano_hole_d/2);
              translate([(0.250*inch-meccano_hole_d)/2,0,0])
                cylinder(h=thickness,r=meccano_hole_d/2);
            }
        } else {
          translate([x,y,0])
            cylinder(h=thickness,r=meccano_hole_d/2);
        }
      }
    }
  }
}

//
// uno_mounting_plate: create an adapter plate to fit an
// Arduino Uno onto standard Meccano hole spacing
//
// x_holes: # of Meccano holes along the length (miniumum and default: 7)
// y_holes: # of Meccano holes along the width (minimum and default: 5)
// elongate_end_holes: true to use elongated holes at both sides (default false)
// thickness: plate thickness (default: 0.1")
//
module uno_mounting_plate(x_holes=7,y_holes=5,elongate_end_holes=false,thickness=0.100*inch) {

  if( x_holes<7 || y_holes<5 ) {
    echo("Minimum # of plate holes is 7x5");
  } else {
    length=x_holes*meccano_hole_spacing;
    width=y_holes*meccano_hole_spacing;
    standoff_height=0.220*inch; // sized for 10mm M3 machine screws with 2.4mm thick nuts
    difference() {
      // create the plate and standoffs
      union() {
        flat_plate(x_holes=x_holes,y_holes=y_holes,thick=0.100*inch,elongate_end_holes=elongate_end_holes,thickness=thickness);
        translate([(length-uno_length())/2,(width-uno_width())/2,0])
          uno_standoffs(standoff_height);
      }
      // remove the mounting holes
      translate([(length-uno_length())/2,(width-uno_width())/2,0])
        uno_holes(standoff_height);
      // add some logo text
      text_offset=meccano_hole_spacing/2;
      text_depth=0.3;
      translate([length/2,width/2+text_offset,thickness-text_depth])
        linear_extrude(height=0.3)
          text("Arduino Uno",halign="center",valign="center",size=5);
      translate([length/2,width/2-text_offset,thickness-text_depth])
        linear_extrude(height=0.3)
          import("Arduino_mounting_plate_Meccano_logo.dxf",convexity=20);
    }
  }
}

uno_mounting_plate(elongate_end_holes=true);
