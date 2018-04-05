// PN 520 rectangular coil plastic former

$fn=120;
base_up=true;          // set to true to print the base on top
                       // or false to print the base on bottom
inch=25.4;             // bottom detail seems to print better
                       // when it's on top (at the expense of 
                       // a crummy looking base top)

rad=2;                 // corner radius
base_thick=2.1;
base_depth=27.4;       // depth (Y) of top
width=24.07;           // width (X) of top and bottom
top_thick=1.6;
top_depth=18.01;       // depth (Y) of top
height=20.9;           // overall height (Z)

chimney_width=13.3;    // chimney interior width
chimney_depth=7.62;    // chimney interior depth
chimney_thick=2;       // guess at chimney wall thickness

eye_rad=4.7/2;         // eyelet radius
eye_depth=6.2;         // offset from front
eye_spacing=inch/2;    // 0.5" apart

base_cutout_height=0.79;
base_cutout_border=1.63;

coil_thickness=1.4;
wire_rad=0.5;
wire_e_x=(width-chimney_width)/2;
wire_e_y=base_depth-top_depth+(top_depth-chimney_depth)/2-chimney_thick-wire_rad;
wire_s_x=(width+chimney_width)/2+chimney_thick+wire_rad;
wire_s_y=wire_e_y-coil_thickness;;

module coil_form() {

  // add the bottom, top and chimney together
  // then subtract the chimney interior, eyelet
  // and wire holes, wire conduits and base cutout
  difference() {
    union() {
      // bottom
      hull() {
        translate([rad,rad,0]) cylinder(h=base_thick,r=rad);
        translate([width-rad,rad,0]) cylinder(h=base_thick,r=rad);
        translate([rad,base_depth-rad,0]) cylinder(h=base_thick,r=rad);
        translate([width-rad,base_depth-rad,0]) cylinder(h=base_thick,r=rad);
      }
      // top
      translate([0,base_depth-top_depth,height-top_thick]) hull() {
        translate([rad,rad,0]) cylinder(h=top_thick,r=rad);
        translate([width-rad,rad,0]) cylinder(h=top_thick,r=rad);
        translate([rad,top_depth-rad,0]) cylinder(h=top_thick,r=rad);
        translate([width-rad,top_depth-rad,0]) cylinder(h=top_thick,r=rad);
      }
      // chimney outside
      translate([(width-chimney_width)/2-chimney_thick,base_depth-top_depth+(top_depth-chimney_depth)/2-chimney_thick,0]) 
        hull() {
          translate([rad,rad,0]) cylinder(h=height,r=rad);
          translate([chimney_width+2*chimney_thick-rad,rad,0]) cylinder(h=height,r=rad);
          translate([rad,chimney_depth+2*chimney_thick-rad,0]) cylinder(h=height,r=rad);
          translate([chimney_width+2*chimney_thick-rad,chimney_depth+2*chimney_thick-rad,0]) cylinder(h=height,r=rad);
        }
    }
    // remove chimney interior
    translate([(width-chimney_width)/2,base_depth-(top_depth+chimney_depth)/2,0]) cube([chimney_width,chimney_depth,height]);
    // remove left eyelet
    translate([(width-eye_spacing)/2,eye_depth,0]) cylinder(h=base_thick,r=eye_rad);
    // remove right eyelet
    translate([(width+eye_spacing)/2,eye_depth,0]) cylinder(h=base_thick,r=eye_rad);
    // remove base cutout
    translate([base_cutout_border,base_cutout_border,0]) cube([width-2*base_cutout_border,base_depth-2*base_cutout_border,base_cutout_height]);
    // remove S wire hole
    translate([wire_s_x,wire_s_y,0]) cylinder(h=base_thick,r=wire_rad);
    // remove E wire hole
    translate([wire_e_x,wire_e_y,0]) cylinder(h=base_thick,r=wire_rad);
    // remove S wire conduit
    linear_extrude(height=base_cutout_height+wire_rad) 
      polygon([[wire_s_x+wire_rad,wire_s_y],[(width+eye_spacing)/2+wire_rad,eye_depth],[(width+eye_spacing)/2-wire_rad,eye_depth],[wire_s_x-wire_rad,wire_s_y]]);
    // remove E wire conduit
    linear_extrude(height=base_cutout_height+wire_rad) 
      polygon([[wire_e_x+wire_rad,wire_e_y],[(width-eye_spacing)/2+wire_rad,eye_depth],[(width-eye_spacing)/2-wire_rad,eye_depth],[wire_e_x-wire_rad,wire_e_y]]);
  }
}

if (base_up) {
  translate([width,0,height]) rotate([180,0,180]) coil_form();
} else {
  coil_form();
}