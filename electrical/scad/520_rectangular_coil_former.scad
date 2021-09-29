// PN 520 rectangular coil plastic former
//
// May 3, 2018 WH - code cleanup and dimension adjustments

base_up=true;          // set to true to print the base on top
                       // or false to print the base on bottom

module rectangular_coil_form(base_up) {

  $fs=0.5;
  $fa=1;
  inch=25.4;
  eps=0.05;

  // rectangular coil form constants
  rad=2;                    // corner radius
  base_thick=0.079*inch;
  base_depth=1.080*inch;    // depth (Y) of top
  width=24.07;              // width (X) of top and bottom
  top_thick=0.060*inch;
  top_depth=0.711*inch;          // depth (Y) of top
  height=0.8335*inch;       // overall height (Z)

  chimney_width=0.505*inch; // chimney interior width
  chimney_depth=0.288*inch; // chimney interior depth
  chimney_thick=1.5;        // guess at chimney wall thickness (from cylindrical coil)

  eye_rad=4.7/2;            // eyelet radius
  eye_depth=6.2;            // offset from front
  eye_spacing=inch/2;       // 0.5" apart

  base_cutout_height=0.79;
  base_cutout_border=1.63;

  coil_thickness=1.4;
  wire_rad=0.020*inch/2;    // 200% of 30AWG radius
  wire_guide_depth=2*wire_rad;
  wire_e_x=(width-chimney_width)/2;
  wire_e_y=base_depth-top_depth+(top_depth-chimney_depth)/2-chimney_thick-wire_rad;
  wire_s_x=(width+chimney_width)/2+chimney_thick+wire_rad;
  wire_s_y=wire_e_y-coil_thickness;

  text_depth=0.3;
  text_ascent=3;

  module rectangular_coil_form_base_down() {

  // add the bottom, top and chimney together
  // then subtract the chimney interior, eyelet
    // and wire holes, wire conduits and base cutout
    difference() {
      union() {
        // bottom
        hull() {
          translate([rad,rad,0])
            cylinder(h=base_thick,r=rad);
          translate([width-rad,rad,0])
            cylinder(h=base_thick,r=rad);
          translate([rad,base_depth-rad,0])
            cylinder(h=base_thick,r=rad);
          translate([width-rad,base_depth-rad,0])
            cylinder(h=base_thick,r=rad);
        }
        // top
        translate([0,base_depth-top_depth,height-top_thick]) hull() {
          translate([rad,rad,0])
           cylinder(h=top_thick,r=rad);
          translate([width-rad,rad,0])
            cylinder(h=top_thick,r=rad);
          translate([rad,top_depth-rad,0])
            cylinder(h=top_thick,r=rad);
          translate([width-rad,top_depth-rad,0])
            cylinder(h=top_thick,r=rad);
        }
        // chimney outside
        translate([(width-chimney_width)/2-chimney_thick,base_depth-top_depth+(top_depth-chimney_depth)/2-chimney_thick,0]) 
          hull() {
            translate([rad,rad,0])
              cylinder(h=height,r=rad);
            translate([chimney_width+2*chimney_thick-rad,rad,0])
              cylinder(h=height,r=rad);
            translate([rad,chimney_depth+2*chimney_thick-rad,0])
              cylinder(h=height,r=rad);
            translate([chimney_width+2*chimney_thick-rad,chimney_depth+2*chimney_thick-rad,0])
              cylinder(h=height,r=rad);
          }
      }
      // remove chimney interior
      translate([(width-chimney_width)/2,base_depth-(top_depth+chimney_depth)/2,-eps])
        cube([chimney_width,chimney_depth,height+2*eps]);
      // remove left eyelet
      translate([(width-eye_spacing)/2,eye_depth,-eps])
        cylinder(h=base_thick+2*eps,r=eye_rad);
      // remove right eyelet
      translate([(width+eye_spacing)/2,eye_depth,-eps])
        cylinder(h=base_thick+2*eps,r=eye_rad);
      // remove base cutout
      translate([base_cutout_border,base_cutout_border,-eps])
        cube([width-2*base_cutout_border,base_depth-2*base_cutout_border,base_cutout_height+eps]);
      // remove S wire hole
      translate([wire_s_x,wire_s_y,-eps])
        cylinder(h=base_thick+2*eps,r=wire_rad);
      // remove E wire hole
      translate([wire_e_x,wire_e_y,-eps])
        cylinder(h=base_thick+2*eps,r=wire_rad);
      // remove S wire conduit
      linear_extrude(height=base_cutout_height+wire_guide_depth) 
        polygon([
          [wire_s_x+wire_rad,wire_s_y],
          [(width+eye_spacing)/2+wire_rad,eye_depth],
          [(width+eye_spacing)/2-wire_rad,eye_depth],
          [wire_s_x-wire_rad,wire_s_y]]);
      // remove E wire conduit
      linear_extrude(height=base_cutout_height+wire_guide_depth) 
        polygon([
          [wire_e_x+wire_rad,wire_e_y],
          [(width-eye_spacing)/2+wire_rad,eye_depth],
          [(width-eye_spacing)/2-wire_rad,eye_depth],
          [wire_e_x-wire_rad,wire_e_y]]);
      // remove coil text
      translate([wire_s_x,wire_s_y,base_cutout_height-eps])
        linear_extrude(height=text_depth+eps)
          rotate([0,180,0])
            text(" S",size=text_ascent,valign="center",halign="left");
      translate([wire_e_x,wire_e_y,base_cutout_height-eps])
        linear_extrude(height=text_depth+eps) 
          rotate([0,180,0])
            text("E ",size=text_ascent,valign="top",halign="right");
    }
  }
  if( base_up ) {
    // bottom detail seems to print better when it's on top
    // (at the expense of a crummy looking base top)
    translate([width,0,height])
      rotate([180,0,180])
        rectangular_coil_form_base_down();
  } else {
    rectangular_coil_form_base_down();
  }
}

rectangular_coil_form(base_up);
