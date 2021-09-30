$fn=32;

//
// Meccano constants
//
inch=25.4;
axle_d=0.168*inch;           // size for standard round Meccano axle
triaxle_round_d=0.172*inch;  // sized to fit a standard Meccano triaxle rod
triaxle_flats_d=3.76;        // ... YMMV
hole_d=0.171*inch;

//
// B015 bracket: the "elephant leg" bracket.
//
// V1.0 April 14, 2018 WH - the quick and dirty version
//
module B015_bracket() {
  //
  // bracket parameters
  //
  minor_hole_spacing=0.250*inch;
  major_hole_interval=2;
  major_hole_spacing=minor_hole_spacing*major_hole_interval;
  //
  width=0.5025*inch;
  depth=0.246*inch;
  hole_surround_d=0.326*inch;
  border_w=0.050*inch;
  inset_depth=0.080*inch;
  inner_ridge_w=0.2365*inch;
  line_w=0.046*inch;
  segment1_holes=6;
  segment2_holes=6;
  segment3_holes=3;
  bend1_angle=45;
  bend2_angle=45;

  // create the form of the bracket. this is used to create the
  // inner cutout, the inner rampart and the actual outer form
  module B015_form(end_r,form_width,form_depth) {
    union() {
      hull() {
        cylinder(h=form_depth,r=end_r);
        translate([0,-form_width/2,0])
          cube([segment1_holes*minor_hole_spacing,form_width,form_depth]);
        translate([segment1_holes*minor_hole_spacing,0,0])
          cylinder(h=form_depth,r=form_width/2);
      }
      translate([segment1_holes*minor_hole_spacing,0,0])
        rotate(bend1_angle)
          union() {
            hull() {
              cylinder(h=form_depth,r=form_width/2);
              translate([segment2_holes*minor_hole_spacing,0,0])
               cylinder(h=form_depth,r=form_width/2);
            }
            translate([segment2_holes*minor_hole_spacing,0,0])
              rotate(bend2_angle)
                hull() {
                  cylinder(h=form_depth,r=form_width/2);
                  translate([0,-form_width/2,0])
                    cube([(segment3_holes-1)*minor_hole_spacing,form_width,form_depth]);
                  translate([(segment3_holes-1)*minor_hole_spacing,0,0])
                    cylinder(h=form_depth,r=end_r);
                }
          }
    }
  }

  // remove the holes (spaced 1/4")
  // or add hole surround (spaced 1/2")
  module B015_holes(hole_r,spacing_multiplier) {
    for( x=[0:spacing_multiplier:segment1_holes] ) {
      translate([x*minor_hole_spacing,0,0])
        cylinder(h=depth,r=hole_r);
    }
    translate([segment1_holes*minor_hole_spacing,0,0])
      rotate(bend1_angle)
        union() {
          for( xy=[0:spacing_multiplier:segment2_holes] ) {
            translate([xy*minor_hole_spacing,0,0])
              cylinder(h=depth,r=hole_r);
          }
          translate([segment2_holes*minor_hole_spacing,0,0])
            rotate(bend2_angle)
              for( y=[0:spacing_multiplier:segment3_holes-1] ) {
                translate([y*minor_hole_spacing,0,0])
                  cylinder(h=depth,r=hole_r);
              }
        }
  }

  // create the lines on the major (1/2" spaced) hole
  module B015_lines(line_x,line_y,line_z) {
    for( x=[major_hole_interval:major_hole_interval:segment1_holes-major_hole_interval] ) {
      translate([x*minor_hole_spacing,0,line_z/2])
        cube([line_x,line_y,line_z],center=true);
    }
    translate([segment1_holes*minor_hole_spacing,0,line_z/2])
      rotate(bend1_angle/2)
        cube([line_x,line_y,line_z],center=true);
    translate([segment1_holes*minor_hole_spacing,0,0])
      rotate(bend1_angle)
        union() {
          for( xy=[major_hole_interval:major_hole_interval:segment2_holes-major_hole_interval] ) {
            translate([xy*minor_hole_spacing,0,line_z/2])
             cube([line_x,line_y,line_z],center=true);
          }
          translate([segment2_holes*minor_hole_spacing,0,line_z/2])
            rotate(bend2_angle/2)
              cube([line_x,line_y,line_z],center=true);
          translate([segment2_holes*minor_hole_spacing,0,0])
            rotate(bend2_angle)
              for( y=[major_hole_interval:major_hole_interval:(segment3_holes)-major_hole_interval] ) {
                translate([y*minor_hole_spacing,0,line_z/2])
                  cube([line_x,line_y,line_z],center=true);
              }
        }
  }

  difference() {
    union() {
      difference() { // create the outer border
        B015_form(hole_surround_d/2,width,depth);
        B015_form(hole_surround_d/2-border_w,width-2*border_w,depth);
      }
      translate([0,0,inset_depth]) // add in the mid layer
        B015_form(hole_surround_d/2,width,depth-2*inset_depth);
      B015_lines(line_w,width,depth,major_hole_interval); // lines on major holes
      B015_form(inner_ridge_w/2,inner_ridge_w,depth); // inner bit
      B015_holes(hole_surround_d/2,major_hole_interval); // major hole surrounds
    }
    B015_holes(hole_d/2,1); // remove all the holes
  }
}

B015_bracket();