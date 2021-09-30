//
// Part #510: insulating plate 5x11
// Part #511: insulating plate 5x5
//
// V1.0 - May 28, 2018 WH - the quick and dirty version
//
$fs=0.75;
$fa=0.375;
eps=0.05;
inch=25.4;

//
// Meccano constants
//
meccano_hole_spacing=0.500*inch;
meccano_hole_d=0.172*inch;

thickness=1.6;

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
              translate([-(0.250*inch-meccano_hole_d)/2,0,-eps])
                cylinder(h=thickness+2*eps,r=meccano_hole_d/2);
              translate([(0.250*inch-meccano_hole_d)/2,0,0])
                cylinder(h=thickness+2*eps,r=meccano_hole_d/2,-eps);
            }
        } else {
          translate([x,y,-eps])
            cylinder(h=thickness+2*eps,r=meccano_hole_d/2);
        }
      }
    }
  }
}

//flat_plate(thickness,2,2); // 505r
//flat_plate(thickness,5,2); // 507t
flat_plate(thickness,11,5); // 510
//flat_plate(thickness,5,5); // 511
//flat_plate(thickness,6,3); // 512b
//flat_plate(thickness,7,5); // 512c